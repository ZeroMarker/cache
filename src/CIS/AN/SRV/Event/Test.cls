Class CIS.AN.SRV.Event.Test Extends %RegisteredObject
{

/// w ##class(CIS.AN.SRV.Event.Test).TriggerArrangeSubmit()
ClassMethod TriggerArrangeSubmit() As %String
{
	write "Test Start>>>",!
	try
	{
		set args=##class(CIS.AN.DTO.Event.Args.OnArrangeSubmit).%New()
		set args.Date="2021-12-27"
		
		set sc=##class(CIS.AN.SRV.Event.OnArrangeSubmit).Trigger(args)
	}
	catch(e)
	{
		write e.DisplayString(),!
	}
	write "Test End<<<",!
	quit ""
}

/// w ##class(CIS.AN.SRV.Event.Test).TriggerStatusChange()
ClassMethod TriggerStatusChange() As %String
{
	write "Test Start>>>",!
	
	try
	{
		set args=##class(CIS.AN.DTO.Event.Args.OnStatusChange).%New()
		set args.RowId="36"
		set args.OriginalStatusCode="Application"
		set args.CurrentStatusCode="Arrange"
		
		set sc=##class(CIS.AN.SRV.Event.OnStatusChange).Trigger(args)
	}
	catch(e)
	{
		write e.DisplayString(),!
	}
	write "Test End<<<",!
	quit ""
}

/// w ##class(CIS.AN.SRV.Event.Test).TriggerRegistration()
ClassMethod TriggerRegistration() As %String
{
	write "Test Start>>>",!
	
	try
	{
		set args=##class(CIS.AN.DTO.Event.Args.OnOperRegister).%New()
		set args.RowId="36"
		
		set sc=##class(CIS.AN.SRV.Event.OnOperRegister).Trigger(args)
	}
	catch(e)
	{
		write e.DisplayString(),!
	}
	write "Test End<<<",!
	quit ""
}

}
