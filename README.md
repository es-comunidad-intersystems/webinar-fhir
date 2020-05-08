

# Iniciar instancia IRIS
```
docker-compose up
```
Podremos acceder al [Mng. Portal](http://localhost:52773/csp/sys/UtilHome.csp)

# Instalación FHIR Server
Abrimos una session de terminal interactiva con IRIS:
```
docker exec -it iris-fhir bash
iris session IRIS
```

Crear un namespace *foundation* donde estará el FHIR Server 
```objectscript
zn "HSLIB"
do ##class(HS.HC.Util.Installer).InstallFoundation("FHIRNamespace")
zn "FHIRNAMESPACE"
```

# Configurar FHIR Server
Utilizaremos la UI aunque también podemos hacerlo de forma prográmatica.
[Mng. Portal > Health > FHIRNamespace](http://localhost:52773/csp/healthshare/fhirnamespace/HS.HC.UI.Home.cls)

Click en *FHIR Configuration* , añadimos un nuevo endpoint:
* Metadata Set: `HL7v40`
* Interaction Stragegy: `HS.FHIRServer.Storage.Json.InteractionStrategy`
* Name: `/csp/healthshare/fhirnamespace/fhir/r4`

Después de añadirlo, editamos su configuración y habilitamos la opción de *Debugging* `Allow Unauthenticated Access` para poder realizar pruebas fácilmente.

# Ejemplos simples
* Metadata - Capability Statement
* Create Patient
* Read Patient
* Modify Patient
* Read Version
* Create Observation

# TODO. Clases
Diagrama herencia
HS.FHIRServer.Storage.Json.InteractionsStrategy
HS.FHIRServer.Storage.Json.Interactions

# Cargar datos FHIR (Synthea)
Echemos un vistazo a alguno de los ficheros FHIR como [este ejemplo](fhir/Alecia465_Hills818_4c93d4af-e649-4646-8c28-6d4f14c489b3.json) y comprueba los *resources* que contiene: Bundle, Encounter, AllergyIntolerance, Claim, Organization, Practitioner, etc.

Los datos del directorio `fhir/` han sido generados con [Synthea](https://github.com/synthetichealth/synthea) utilizando el comando:
```console
$ ./run_synthea -s 12345 -p 50
```

Vamos a cargar los ficheros con datos generados en IRIS utilizando `HS.FHIRServer.Tools.DataLoader`:
```
set status = ##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles("/app/fhir/","FHIRServer","/csp/healthshare/fhirnamespace/fhir/r4")
```

# TODO: Consultar datos generados
Ejemplos de queries más complejas (contains, encounters, etc.)


# TODO: utilización de operaciones
TODO: hablar de cómo implementar operaciones en FHIR Server

# Debugging
```objectscript
set ^FSLogChannel("all") = 1
```

[Mng. Portal > System Explorer > Globals (FHIRNAMESPACE) > FSLOG](http://localhost:52773/csp/sys/exp/UtilExpGlobalView.csp?$ID2=FSLOG&$NAMESPACE=FHIRNAMESPACE)


```objectscript
set ^%ISCLOG=5 
set ^%ISCLOG("Category","HSFHIR")=5 
set ^%ISCLOG("Category","HSFHIRServer")=5
```

[Mng. Portal > System Explorer > Globals (%SYS) > ISCLOG](http://localhost:52773/csp/sys/exp/UtilExpGlobalView.csp?$ID2=ISCLOG&$NAMESPACE=%SYS)


# SMART
```
git clone https://github.com/smart-on-fhir/growth-chart-app
npm install
npm start
```

## Growth chart

http://localhost:9000/launch.html?fhirServiceUrl=http://launch.smarthealthit.org/v/r3/fhir
launch.html -> patientId: smart-1137192

http://localhost:9000/launch.html?fhirServiceUrl=http://localhost:52773/csp/healthshare/fhirnamespace/fhir/r4
launch.html -> patientId: 1

http://localhost:9000/launch.html?iss=http://localhost:52773/csp/healthshare/fhirnamespace/fhir/r4&patientId=3
launch.html modificado

```
<script>
    var url = new URL(window.location.href);
    var patientId = url.searchParams.get("patientId");
    
    FHIR.oauth2.authorize({
    "client_id": "growth_chart",
    "patientId": patientId,
    "scope":  "patient/Observation.read patient/Patient.read offline_access",
    // "client_id": "944d96a0-4caf-4a96-813e-bc38aadb1169" // HSPC
    // "client_id": "5570f8be-6caf-4915-ae15-69545ab38e68" // Cerner
    });
</script>
```
Adela471 Pfeffer420 tiene datos
