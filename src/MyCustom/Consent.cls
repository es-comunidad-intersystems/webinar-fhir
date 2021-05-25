/// Dummy custom Consent class
Class MyCustom.Consent Extends %Persistent
{

ClassMethod Consented(obj As %DynamicObject, user As %String, roles As %String) As %Boolean
{
    quit 1
}

Storage Default
{
<Data name="ConsentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^MyCustom.ConsentD</DataLocation>
<DefaultData>ConsentDefaultData</DefaultData>
<IdLocation>^MyCustom.ConsentD</IdLocation>
<IndexLocation>^MyCustom.ConsentI</IndexLocation>
<StreamLocation>^MyCustom.ConsentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
