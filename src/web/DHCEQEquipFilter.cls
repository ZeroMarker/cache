Class web.DHCEQEquipFilter Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetEquipFilter(FilterData) As %Query(ROWSPEC = "ID:%String,Type:%String,Filter:%String,FilterDR:%String,Logic:%String")
{
}

ClassMethod GetEquipFilterExecute(ByRef qHandle As %Binary, FilterData) As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	if FilterData="" 
	{
		d ResetVariablesRowList
		s Type="1"
		d OutputRowList
	}
	else
	{
		s FilterData="&vData=^"_FilterData
		s NameStr=##Class(web.DHCEQCommon).GetDataByName(FilterData,"NameStr")
		s UseLocDRStr=##Class(web.DHCEQCommon).GetDataByName(FilterData,"UseLocDRStr")
		s ProviderDRStr=##Class(web.DHCEQCommon).GetDataByName(FilterData,"ProviderDRStr")
		s EquipTypeDRStr=##Class(web.DHCEQCommon).GetDataByName(FilterData,"EquipTypeDRStr")
		s StatusStr=##Class(web.DHCEQCommon).GetDataByName(FilterData,"StatusStr")
		s ModelDRStr=##Class(web.DHCEQCommon).GetDataByName(FilterData,"ModelDRStr")
		s NoStr=##Class(web.DHCEQCommon).GetDataByName(FilterData,"NoStr")
		if (NameStr'="")
		{
			d ResetVariablesRowList
			s Type="1"
			s Len=$l(NameStr,",")
			for i=1:1:Len
			{
				s Filter=$p(NameStr,",",i)
				d OutputRowList
			}
		}
		if (UseLocDRStr'="")
		{
			d ResetVariablesRowList
			s Type="2"
			s Len=$l(UseLocDRStr,",")
			for i=1:1:Len
			{
				s FilterDR=$p(UseLocDRStr,",",i)
				s Filter=##Class(web.DHCEQCommon).GetTrakNameByID("dept",FilterDR)
				d OutputRowList
			}
		}
		if (ProviderDRStr'="")
		{
			d ResetVariablesRowList
			s Type="3"
			s Len=$l(ProviderDRStr,",")
			for i=1:1:Len
			{
				s FilterDR=$p(ProviderDRStr,",",i)
				s Filter=##Class(web.DHCEQCommon).GetTrakNameByID("prov",FilterDR)
				d OutputRowList
			}
		}
		if (EquipTypeDRStr'="")
		{
			d ResetVariablesRowList
			s Type="4"
			s Len=$l(EquipTypeDRStr,",")
			for i=1:1:Len
			{
				s FilterDR=$p(EquipTypeDRStr,",",i)
				s Filter=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",FilterDR)
				d OutputRowList
			}
		}
		if (StatusStr'="")
		{
			d ResetVariablesRowList
			s Type="5"
			s Len=$l(StatusStr,",")
			for i=1:1:Len
			{
				s FilterDR=$p(StatusStr,",",i)
				s Filter=##Class(web.DHCEQEquip).GetEquipStatusDisplay(FilterDR)
				d OutputRowList
			}
		}
		if (ModelDRStr'="")
		{
			d ResetVariablesRowList
			s Type="6"
			s Len=$l(ModelDRStr,",")
			for i=1:1:Len
			{
				s FilterDR=$p(ModelDRStr,",",i)
				s Filter=##Class(web.DHCEQCommon).GetTrakNameByID("model",FilterDR)
				d OutputRowList
			}
		}
		if (NoStr'="")
		{
			d ResetVariablesRowList
			s Type="7"
			s Len=$l(NoStr,",")
			for i=1:1:Len
			{
				s Filter=$p(ProviderDRStr,",",i)
				d OutputRowList
			}
		}
	}
	Quit $$$OK
OutputRowList
	s Data=$lb(ID,Type,Filter,FilterDR,Logic)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesRowList
	s (ID,Type,Filter,FilterDR,Logic)=""
	quit
}

ClassMethod GetEquipFilterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipFilterExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEquipFilterClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipFilterExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
