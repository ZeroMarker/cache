Class CIS.OPApp.SRV.Event.Test Extends %RegisteredObject
{

/// w ##class(CIS.OPApp.SRV.Event.Test).TriggerRegistration()
ClassMethod TriggerRegistration() As %String
{
	write "Test Start>>>",!
	
	try
	{
		set args=##class(CIS.OPApp.DTO.Event.Args.OnOperRegister).%New()
		set args.RowId="981"
		
		set sc=##class(CIS.OPApp.SRV.Event.OnOperRegister).Trigger(args)
	}
	catch(e)
	{
		write e.DisplayString(),!
	}
	write "Test End<<<",!
	quit ""
}

}
