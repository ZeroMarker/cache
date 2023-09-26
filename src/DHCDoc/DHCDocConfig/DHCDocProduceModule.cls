Class DHCDoc.DHCDocConfig.DHCDocProduceModule Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod InsertProduceModule(RowID, Code, Desc, LinkType, Linkcsp, ProduceLink, ProduceModuleLink, Remark, Linkcsplocation, SaveMethod, ShowMethod)
{
	q:((Code="")||(Desc="")) ""
	if (RowID["M") s RowID=$P(RowID,"M",2)
	if (RowID["S") s RowID=$P(RowID,"S",2)
	if (ProduceLink["M") s ProduceLink=$P(ProduceLink,"M",2)
	if (ProduceModuleLink["S") s ProduceModuleLink=$P(ProduceModuleLink,"S",2)
	if (RowID=""){
		&SQL(insert into SQLUser.DHCDocProduceModule 
		(ProduceModuleCode,ProduceModuleDesc,Active,LinkType,Linkcsp,ProduceLink,ProduceModuleLink,Remark,Linkcsplocation,SaveMethod,ShowMethod
		) Values(:Code,:Desc,"Y",:LinkType,:Linkcsp,:ProduceLink,:ProduceModuleLink,:Remark,:Linkcsplocation,:SaveMethod,:ShowMethod))
	}else{
		&SQL(Update SQLUser.DHCDocProduceModule set ProduceModuleCode=:Code,ProduceModuleDesc=:Desc, 
		LinkType=:LinkType ,Linkcsp=:Linkcsp, 
		ProduceLink=:ProduceLink ,ProduceModuleLink=:ProduceModuleLink, 
		Remark=:Remark ,Linkcsplocation=:Linkcsplocation ,SaveMethod=:SaveMethod,ShowMethod=:ShowMethod where RowID=:RowID)
		}
	s rtn=SQLCODE
	q rtn
}

ClassMethod delectProduceModule(RowID)
{
	q:RowID="" ""
	if (RowID["M") s RowID=$P(RowID,"M",2)
	if (RowID["S") s RowID=$P(RowID,"S",2)
	&SQL(Update SQLUser.DHCDocProduceModule set 
		Active="N" where RowID=:RowID)
	s rtn=SQLCODE
	q rtn
}

ClassMethod ShowProduceModule(RowID)
{
	q:RowID="" ""
	if (RowID["M") s SubRowid=$P(RowID,"M",2)
	if (RowID["S") s SubRowid=$P(RowID,"S",2)
	s moduleCode=$P(^DHCDocProduceModule(SubRowid),"^",1)
	s moduleDesc=$P(^DHCDocProduceModule(SubRowid),"^",2)
	s LinkType=$P(^DHCDocProduceModule(SubRowid),"^",4)
	s csplocation=$P(^DHCDocProduceModule(SubRowid),"^",9)
	s LinkTypecsp=$P(^DHCDocProduceModule(SubRowid),"^",5)
	s moduleRemark=$P(^DHCDocProduceModule(SubRowid),"^",8)
	s ProduceLink=$P(^DHCDocProduceModule(SubRowid),"^",6)
	s ProduceModuleLink=$P(^DHCDocProduceModule(SubRowid),"^",7)
	s SaveMethod=$P(^DHCDocProduceModule(SubRowid),"^",10)
	s ShowMethod=$P(^DHCDocProduceModule(SubRowid),"^",11)
	s rtn=moduleCode_$C(1)_moduleDesc_$C(1)_LinkType_$C(1)_csplocation_$C(1)_LinkTypecsp_$C(1)_moduleRemark
	s rtn=rtn_$C(1)_ProduceLink_$C(1)_ProduceModuleLink_$C(1)_SaveMethod_$C(1)_ShowMethod
	q rtn
}

/// w ##class(DHCDoc.DHCDocConfig.DHCDocProduceModule).FindMasterProduceTree()
ClassMethod FindMasterProduceTree(desc)
{
	n (desc)
	s RetObj=[]
	s RowID=0
	for{
		s RowID=$O(^DHCDocProduce(RowID))
		q:RowID=""
		s ProcduceCode=$P(^DHCDocProduce(RowID),"^",1)
		s ProcduceDesc=$P(^DHCDocProduce(RowID),"^",2)
		s ProcduceActive=$P(^DHCDocProduce(RowID),"^",3)
		continue:ProcduceActive="N"
		s MasterObj={}
		s MasterObj.id="M"_RowID
		s MasterObj.text="<label style='font-weight:bold'>"_ProcduceDesc_" ["_ProcduceCode_"]"_"</label>"
		s MasterObj.masterid=""
		s MasterObj.LinkType=""
		s MasterObj.Code=ProcduceCode
		s SubRowid="0"
		s MasterObj.children=[]
		s MasterFlag=0
		for{
			s SubRowid=$O(^DHCDocProduceModulei("PorduceLink",RowID,SubRowid))
			q:SubRowid=""
			Continue:'..isExistMasterProduceTree(desc,SubRowid)
			s Active=$P(^DHCDocProduceModule(SubRowid),"^",3)
			continue:Active="N"
			s subObj={}
			s SubDesc=$P(^DHCDocProduceModule(SubRowid),"^",2)
			s LinkType=$P(^DHCDocProduceModule(SubRowid),"^",4)
			if (LinkType="outlinkcsp") s SubDesc="【外联】"_SubDesc
			s subObj.id="S"_SubRowid
			s subObj.text=SubDesc
			s subObj.masterid="M"_RowID
			s LinkType=$P(^DHCDocProduceModule(SubRowid),"^",4)
			s subObj.LinkType=LinkType
			s Code=$P(^DHCDocProduceModule(SubRowid),"^",1)
			s subObj.Code=Code
			s subObj.children=..GetSubProduceTree(SubRowid,desc)
			if (subObj.children.%Size()=0) d subObj.%Remove("children")
			d MasterObj.children.%Push(subObj)
			b ;dddd
			s MasterFlag=1
			}
		if (MasterObj.children.%Size()=0) d MasterObj.%Remove("children")
		b ;dd
		d RetObj.%Push(MasterObj)
	}
	q RetObj.%ToJSON()
}

ClassMethod isExistMasterProduceTree(desc, SubRowid)
{
	n (desc,SubRowid)
	if desc="" q 1
	s isExistFlag=0
	s ID="" s ID=$O(^DHCDocProduceModulei("ModuleLink",SubRowid,""))
	if (ID=""){
		s Code=$P(^DHCDocProduceModule(SubRowid),"^",1)
		s SubDesc=$P(^DHCDocProduceModule(SubRowid),"^",2)
		if ((Code[desc)||(SubDesc[desc)) s isExistFlag=1
	}
	Q:ID="" isExistFlag
	s ID=""
	for {
		s ID=$o(^DHCDocProduceModulei("ModuleLink",SubRowid,ID)) 
		q:(ID="")||(isExistFlag=1)
		s isExistFlag=..isExistMasterProduceTree(desc, ID)
		}
	q isExistFlag
}

ClassMethod GetSubProduceTree(SubRowID, desc)
{
	n (SubRowID,desc)
	s SubRetObj=[]
	s RetRowid="0"
	for{
		s RetRowid=$O(^DHCDocProduceModulei("ModuleLink",SubRowID,RetRowid))
		q:RetRowid=""
		Continue:'..isExistMasterProduceTree(desc,RetRowid)
		s Active=$P(^DHCDocProduceModule(RetRowid),"^",3)
		continue:Active="N"
		s ProducesubObj={}
		s SubDesc=$P(^DHCDocProduceModule(RetRowid),"^",2)
		s ProducesubObj.id="S"_RetRowid
		s LinkType=$P(^DHCDocProduceModule(RetRowid),"^",4)
		if (LinkType="outlinkcsp") s SubDesc="【外联】"_SubDesc
		s ProducesubObj.text=SubDesc
		s ProducesubObj.masterid="S"_SubRowID
		s LinkType=$P(^DHCDocProduceModule(RetRowid),"^",4)
		s ProducesubObj.LinkType=LinkType
		s Code=$P(^DHCDocProduceModule(RetRowid),"^",1)
		s ProducesubObj.Code=Code
		s ProducesubObj.children=..GetSubProduceTree(RetRowid,desc)
		if (ProducesubObj.children.%Size()=0) d ProducesubObj.%Remove("children")
		d SubRetObj.%Push(ProducesubObj)
		}
	q SubRetObj
}

ClassMethod InsertModuleConfig(ModuleRowID, RowID, Code, Desc, ConfigType, ConfigDataType, ConfigData, ConfigDataReMark)
{
	q:ModuleRowID=""||Code=""||Desc=""||ConfigType=""
	s ^tempqujian("InsertModuleConfig")=$lb(ModuleRowID, RowID, Code, Desc, ConfigType, ConfigDataType, ConfigData, ConfigDataReMark)
	s rtn=""
	if (ModuleRowID["M") s ModuleRowID=$P(ModuleRowID,"M",2)
	if (ModuleRowID["S") s ModuleRowID=$P(ModuleRowID,"S",2)
	if (RowID=""){
		s ChirdRowid=$o(^DHCDocProduceModule(ModuleRowID,"I",""),-1)
		if ChirdRowid'="" s DocProduceModuleChildSub=ChirdRowid+1
		else  s DocProduceModuleChildSub=1
		}
	if (RowID=""){
		&SQL(insert into SQLUser.DHCDocProduceModuleConfig
		(DocProduceModuleParRef,ModuleConfigCode,ModuleConfigDesc,ModuleConfigType,
		ModuleConfigDataType,ModuleConfigData,ModuleConfigRemark,DocProduceModuleChildSub
		) Values(:ModuleRowID,:Code,:Desc,:ConfigType,:ConfigDataType,:ConfigData,:ConfigDataReMark,:DocProduceModuleChildSub))
		s rtn=SQLCODE
	}else{
		&SQL(Update SQLUser.DHCDocProduceModuleConfig set ModuleConfigCode=:Code,ModuleConfigDesc=:Desc, 
		ModuleConfigType=:ConfigType,ModuleConfigDataType=:ConfigDataType,ModuleConfigData=:ConfigData,
		ModuleConfigRemark=:ConfigDataReMark
		where RowID =:RowID)
		s rtn=SQLCODE
	}
	b ;
	q rtn
}

ClassMethod DelectModuleConfig(RowID)
{
	q:RowID="" ""
	&SQL(DELETE SQLUser.DHCDocProduceModuleConfig where RowID =:RowID)
	q SQLCODE
}

Query FindModuleConfig(ModuleRowID) As %Query(ROWSPEC = "RowID:%String,ConfigCode:%String,ConfigDesc:%String,ConfigType:%String,ConfigDataReMark:%String,ConfigDataType:%String,ConfigData:%String")
{
}

ClassMethod FindModuleConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindModuleConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindModuleConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindModuleConfigExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindModuleConfigExecute(ByRef qHandle As %Binary, ModuleRowID) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocProduce","FindDocProduce","")
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	if (ModuleRowID["M") s ModuleRowID=$P(ModuleRowID,"M",2)
	if (ModuleRowID["S") s ModuleRowID=$P(ModuleRowID,"S",2)
	s RowID=0
	for{
		s RowID=$O(^DHCDocProduceModule(ModuleRowID,"I",RowID))
		q:RowID=""
		s ConfigCode=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",1)
		s ConfigDesc=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",2)
		s ConfigType=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",3)
		s ConfigType=$case(ConfigType,"text":"文本","check":"勾选框","Combobox":"下拉框单选","ComboboxM":"下拉框多选","LinkBottom":"链接按钮",:ConfigType)
		s ConfigDataType=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",4)
		s ConfigDataType=$case(ConfigDataType,"JSON":"JSON数据","M":"M表达式",:ConfigDataType)
		s ConfigDataReMark=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",5)
		s ConfigData=$g(^DHCDocProduceModule(ModuleRowID,"I",RowID,"Data"))
		set Data=$lb(ModuleRowID_"||"_RowID,ConfigCode,ConfigDesc,ConfigType,ConfigDataReMark,ConfigDataType,ConfigData)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// w ##class("DHCDoc.DHCDocConfig.DHCDocProduceModule").CreatFrame(2)
ClassMethod CreatFrame(RowID)
{
	q:RowID="" ""
	s rtn=""
	if (RowID["M") s RowID=$P(RowID,"M",2)
	if (RowID["S") s RowID=$P(RowID,"S",2)
	s LinkType=$P(^DHCDocProduceModule(RowID),"^",4)
	if (LinkType="indepcsp"){
		s LinkTypecsp=$P(^DHCDocProduceModule(RowID),"^",5)
		s rtn="<iframe scrolling='auto' frameborder='0'  src='"_LinkTypecsp_"' style='width:100%;height:98%;'></iframe>"
	}elseif (LinkType="outlinkcsp"){
		s LinkTypecsp=$P(^DHCDocProduceModule(RowID),"^",5)
		s rtn="<iframe scrolling='auto' frameborder='0'  src='"_LinkTypecsp_"' style='width:100%;height:98%;'></iframe>"
	}elseif(LinkType="linkcsp"){
		s csplocation=$P(^DHCDocProduceModule(RowID),"^",9)
		s LinkTypecsp=$P(^DHCDocProduceModule(RowID),"^",5)
		s rtn="<div data-options='region:"_""""_"center"_""""_",border:false,split:false' style=''>"
		s rtn=rtn_"<div class='hisui-layout' data-options='fit:true,border:false'>"
		if (csplocation="up"){s csplocation="north"
		s rtn=rtn_"<div data-options='region:"_""""_csplocation_""""_",border:false,split:false,collapsible:false' style='height: 400px;border-radius:5px;border:1px solid #ccc;'>"
		}elseif(csplocation="down"){s csplocation="south"
		s rtn=rtn_"<div data-options="""_"region:'"_csplocation_"',border:false,split:false,collapsible:false"""_" style="""_"height: 400px;border-radius:5px;border:1px solid #ccc;"""_">"
		}elseif(csplocation="left"){s csplocation="east"
		s rtn=rtn_"<div data-options='region:"_""""_csplocation_""""_",border:false,split:false,collapsible:false' style='width:400px;border-radius:5px;border:1px solid #ccc;'>"
		}elseif(csplocation="right"){s csplocation="west"
		s rtn=rtn_"<div data-options='region:"_""""_csplocation_""""_",border:false,split:false,collapsible:false' style='width:400px;border-radius:5px;border:1px solid #ccc;'>"
		}
		s rtn=rtn_"<iframe  frameborder='0' scrolling='yes' src='"_LinkTypecsp_"' style='width:100%;height:98%;'></iframe>"
		s rtn=rtn_"</div>"
		s rtn=rtn_"<div data-options='region:"_""""_"center"_""""_",border:false,split:false' id='mainPanlelinkcsp' style='height: 500px;; padding:10px 10px 10px 0;'>"
		s rtn=rtn_"<a style='margin: 10px;' class='hisui-linkbutton' id='BSave"_RowID_"' data-options=''>保存</a>"
		s rtn=rtn_"<div  class='hisui-panel panel-card' title='设置' data-options='headerCls:"_""""_"panel-header-card"_""""_"'>"
		s rtn=rtn_..CreatModuleConfig(RowID)
		s rtn=rtn_"</div>"
		s rtn=rtn_"</div>"
		s rtn=rtn_"</div>"
		s rtn=rtn_"</div>"
	}elseif(LinkType="none"){
		if (..CreatModuleConfig(RowID)="") q ""
		s rtn=rtn_"<div data-options='region:"_""""_"center"_""""_",border:false,split:false' id='mainPanlelinkcsp' style='height: 500px;; padding:10px 10px 10px 0;'>"
		s rtn=rtn_"<a style='margin: 10px;'class='hisui-linkbutton' id='BSave"_RowID_"' data-options=''>保存</a>"
		s rtn=rtn_"<div  class='hisui-panel panel-card' title='设置' data-options='headerCls:"_""""_"panel-header-card"_""""_"'>"
		s rtn=rtn_..CreatModuleConfig(RowID)
		s rtn=rtn_"</div>"
		s rtn=rtn_"</div>"
	}elseif((LinkType="loc")||(LinkType="group")||(LinkType="arcim")){
		s rtn=rtn_"<div data-options='region:"_""""_"west"_""""_",split:true,border:false' style='height:280px;width:312px'>" 
		s rtn=rtn_"<div class='hisui-panel' title='列表' data-options='fit:true,headerCls:"_""""_"panel-header-gray"_""""_"'>" 
		s rtn=rtn_"<input id='SearchItem"_RowID_"' class='hisui-searchbox' style='width:300px' data-options='searcher:searchItem,prompt:"_""""_"请输入"_""""_"'></input>"  
		s Code=$P(^DHCDocProduceModule(RowID),"^",1)
		s rtn=rtn_"<table id='"_"tabList"_Code_RowID_"'></table>"
		s rtn=rtn_"</div>"
  		s rtn=rtn_"</div>"
		s rtn=rtn_"<div data-options='region:"_""""_"center"_""""_",border:false,split:false' id='mainPanlelinkcsp"_RowID_"' style='padding:10px 10px 10px 0;'>"
		s rtn=rtn_"<a style='margin: 10px;'class='hisui-linkbutton' id='BSave"_RowID_"' data-options=''>保存</a>"
		s rtn=rtn_"<div  class='hisui-panel panel-card' title='设置' data-options='headerCls:"_""""_"panel-header-card"_""""_"'>"
		s rtn=rtn_..CreatModuleConfig(RowID)
		s rtn=rtn_"</div>"
		s rtn=rtn_"</div>"
		}
	if (LinkType'="indepcsp"){
		 s Hosprtn="<div class='hisui-layout' data-options='fit:true,border:false'>"
		s Hosprtn=Hosprtn_	"<div data-options='region:"_""""_"north"_""""_",split:false,border:false' style='height:51px;'>"
		s Hosprtn=Hosprtn_	"<table class='search-table' id='hospidtab'>"
		 s Hosprtn=Hosprtn_"<tr><td class='r-label'><label id='_HospListLabel' for='_HospList' style='color:red;margin:0 10px 0 10px' class='r-label'>医院</label>"
			s Hosprtn=Hosprtn_"</td><td><input id='_HospList"_RowID_"'/></td></tr></table>"
			s Hosprtn=Hosprtn_"</div>"
			s rtn=Hosprtn_rtn_"</div>"	
		}
	q rtn
}

ClassMethod CreatModuleConfig(RowID)
{
	q:RowID="" ""
	s subRowid=0
	s ModuleConfigrtn=""
	for{
		s subRowid=$O(^DHCDocProduceModule(RowID,"I",subRowid))
		q:subRowid=""
		s ConfigCode=$P(^DHCDocProduceModule(RowID,"I",subRowid),"^",1)
		s ConfigDesc=$P(^DHCDocProduceModule(RowID,"I",subRowid),"^",2)
		s ConfigType=$P(^DHCDocProduceModule(RowID,"I",subRowid),"^",3)
		if (ConfigType="text"){
			s ModuleConfigrtn=ModuleConfigrtn_"<div><label style='padding: 10px;'>"_ConfigDesc_"</label><input id='"_ConfigCode_"_"_RowID_"_"_subRowid_"' class='textbox' style=''></div>"
		}elseif(ConfigType="check"){
			s ModuleConfigrtn=ModuleConfigrtn_"<div><input class='hisui-checkbox' type='checkbox' label='"_ConfigDesc_"' id='"_ConfigCode_"_"_RowID_"_"_subRowid_"'></div>"
		}elseif(ConfigType="Combobox"){
			s ModuleConfigrtn=ModuleConfigrtn_"<div><label style='padding: 10px;'>"_ConfigDesc_"</label><input id='"_ConfigCode_"_"_RowID_"_"_subRowid_"' class='hisui-combobox textbox' style=''></div>"
		}elseif(ConfigType="ComboboxM"){
			s ModuleConfigrtn=ModuleConfigrtn_"<div><label style='padding: 10px;' >"_ConfigDesc_"</label><input id='"_ConfigCode_"_"_RowID_"_"_subRowid_"' class='hisui-combobox textbox' style=''></div>"
		}
	}
	q ModuleConfigrtn
}

/// w ##class("DHCDoc.DHCDocConfig.DHCDocProduceModule").GetProduceModuleJSON("1||1")
ClassMethod GetProduceModuleJSON(RowID, HospID As %String = "")
{
	q:RowID="" ""
	s MasterRowID=+RowID
	s SubRowID=$P(RowID,"||",2)
	s rtn=""
	s ConfigDataType=$P(^DHCDocProduceModule(MasterRowID,"I",SubRowID),"^",4)
	s ConfigData=$g(^DHCDocProduceModule(MasterRowID,"I",SubRowID,"Data"))
	if (ConfigDataType="M"){
		s str="s rtn="_ConfigData
		x str
	}else{
		s rtn=ConfigData	
			}
	q rtn
}

Query FindModuleConfigtab(ModuleRowID, HospID As %String = "", desc As %String = "") As %Query(ROWSPEC = "RowID:%String,Desc:%String,Code:%String")
{
}

ClassMethod FindModuleConfigtabClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindModuleConfigtabExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindModuleConfigtabFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindModuleConfigtabExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindModuleConfigtabExecute(ByRef qHandle As %Binary, ModuleRowID, HospID As %String = "", desc As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DHCDocProduceModule","FindModuleConfigtab","2",2,"")
	;n (ModuleRowID, HospID, desc)
	s ^TempModuleConfigtab=$lb(ModuleRowID, HospID, desc)
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	if (ModuleRowID["M") s ModuleRowID=$P(ModuleRowID,"M",2)
	if (ModuleRowID["S") s ModuleRowID=$P(ModuleRowID,"S",2)
	s LinkType=$P(^DHCDocProduceModule(ModuleRowID),"^",4)
	if (LinkType="loc"){
	    s ctlocrowid=0 
	    for {
		    s ctlocrowid=$o(^CTLOC(ctlocrowid)) q:ctlocrowid=""  d
		    continue:'$d(^CTLOC(ctlocrowid))
		    s locHospId=$p(^CTLOC(ctlocrowid),"^",22)
		    continue:(locHospId'=HospID)&(locHospId'="")&(HospID'="")
		    s LocActiveFrom=+$p($g(^CTLOC(ctlocrowid)),"^",24)
			s LocActiveTo=+$p($g(^CTLOC(ctlocrowid)),"^",25)
			continue:((LocActiveFrom'=0)&&(LocActiveFrom>+$h))||((LocActiveTo<+$h)&&(LocActiveTo'=0))
		    s ctlocdesc=$p(^CTLOC(ctlocrowid),"^",2)
		    continue:##class(web.DHCOPAdmReg).CheckLocDesc(ctlocrowid,desc)'=1
		    s Desc=ctlocdesc
		    s RowID=ctlocrowid
		    s Code=$p(^CTLOC(ctlocrowid),"^",1)
		    set Data=$lb(RowID,Desc,Code)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		    
		   }
	}elseif(LinkType="group"){
		Set rs=##Class(%ResultSet).%New("web.DHCBL.Configure.PrefParas:GetGroup")
 		Set Status=rs.Execute(desc)
		If 'Status Quit
	 	While rs.Next() {
		 	Set Desc=rs.GetData(1)  
		 	Set Id=rs.GetData(2)
		 	continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_Group",Id,HospID)
			s ActiveFlag=$p(^SSU("SSGRP",Id),"^",151)
			continue:ActiveFlag="N"
		 	Set Code=Id
		 	set Data=$lb(Id,Desc,Code)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}	
	}elseif(LinkType="arcim"){
		s itmmastid=0
		for {
			s itmmastid=$O(^ARCIM(itmmastid))
			q:itmmastid=""
			s itmmastver=0
			for {
				s itmmastver=$O(^ARCIM(itmmastid,itmmastver))
				q:itmmastver=""
				s arcimid=itmmastid_"||"_itmmastver
				continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",arcimid,HospID)="N"
				s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) //医嘱项代码
				s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
				continue:(desc'="")&(arcitmdesc'[desc)
				continue:($g(desc)'="")&(arcitmcode'[desc)
				set Data=$lb(arcimid,arcitmdesc,arcitmcode)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
				}
			}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// w ##class(DHCDoc.DHCDocConfig.DHCDocProduceModule).SaveProduceModuleValue(ObjStr)
ClassMethod SaveProduceModuleValue(Obj)
{
	s ^tempqujian("SaveProduceModuleValue")=$LB(Obj)
	s HospID=Obj.HospID
	s Type=Obj.Type
	s JsonAry=Obj.JsonAry
	s TypeValue=Obj.TypeValue
	s JsonAryStr=JsonAry.%ToJSON()
	s JsonAryObj=##class(DHCDoc.Util.FromXML).Json2Arr(JsonAryStr)
	for i=1:1:JsonAryObj.%Size() {
		s dataObj=JsonAryObj.GetAt(i)
		s Code=dataObj.GetAt("code")	
		s Value=dataObj.GetAt("value")
		if (Type="none"){
			d ##class(web.DHCDocConfig).SaveConfig(Code_$C(1)_Value,HospID)
		}else{
			d ##class(web.DHCDocConfig).SaveConfig1(Code,Type_TypeValue,Value,HospID)
		}
	}
	q 0
}

/// w ##class(DHCDoc.DHCDocConfig.DHCDocProduceModule).SaveProduceModuleMethod(ObjStr)
ClassMethod SaveProduceModuleMethod(ObjStr, ModuleRowID)
{
	s ^tempqujian("SaveProduceModuleMethod")=$lb(ObjStr, ModuleRowID)
	if (ModuleRowID["M") s ModuleRowID=$P(ModuleRowID,"M",2)
	if (ModuleRowID["S") s ModuleRowID=$P(ModuleRowID,"S",2)
	s SaveMethod=$P(^DHCDocProduceModule(ModuleRowID),"^",10)
	s rtn=0
	if (SaveMethod'=""){
		s Obj={}.%FromJSON(ObjStr)
		x "s rtn="_SaveMethod
		}
	q rtn
}

/*ClassMethod ShowOneProduceModuleValue(ModuleRowID, HospID)
{
	n (ModuleRowID, HospID)
	if (ModuleRowID["M") s ModuleRowID=$P(ModuleRowID,"M",2)
	if (ModuleRowID["S") s ModuleRowID=$P(ModuleRowID,"S",2)
	s DataList=""
	s RowID=0
	for{
		s RowID=$O(^DHCDocProduceModule(ModuleRowID,"I",RowID))
		q:RowID=""
		s ConfigCode=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",1)
		s ConfigDesc=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",2)
		s ConfigType=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",3)
		s ConfigDataType=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",4)
		s Value=..%GetConfig(ConfigCode,HospID)
		if (Value=0) s Value=""
		if (DataList=""){
			s DataList=ConfigCode_$C(1)_ModuleRowID_"||"_RowID_$C(1)_ConfigType_$C(1)_Value
		}else{
			s DataList=DataList_$C(2)_ConfigCode_$C(1)_ModuleRowID_"||"_RowID_$C(1)_ConfigType_$C(1)_Value	
		}
	}
	q DataList
}*/
ClassMethod ShowOneProduceModuleValue(Obj)
{
	s HospID=Obj.HospID
	s ModuleRowID=Obj.ModuleRowID
	s Type=Obj.Type
	s TypeValue=Obj.TypeValue
	s RowID=0
	s Rtn=[]
	for{
		s RowID=$O(^DHCDocProduceModule(ModuleRowID,"I",RowID))
		q:RowID=""
		s ConfigCode=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",1)
		s ConfigDesc=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",2)
		s ConfigType=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",3)
		s ConfigDataType=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",4)
		if (Type="none"){
			s Value=..%GetConfig(ConfigCode,HospID)
		}else{
			s SubNote=Type_"_"_TypeValue
			s Value=..%GetConfig1(ConfigCode,SubNote,HospID)
		}
		s rtnobj={}
		s rtnobj.code=ConfigCode
		s rtnobj.value=Value
		d Rtn.%Push(rtnobj)
	}
	q Rtn
}

/// w ##class(DHCDoc.DHCDocConfig.DHCDocProduceModule).GetProduceModuleMethod(1,2,"none","")
ClassMethod GetProduceModuleMethod(ModuleRowID, HospID, Type, TypeValue)
{
	if (ModuleRowID["M") s ModuleRowID=$P(ModuleRowID,"M",2)
	if (ModuleRowID["S") s ModuleRowID=$P(ModuleRowID,"S",2)
	s ShowMethod=$P(^DHCDocProduceModule(ModuleRowID),"^",11)
	s Obj={}
	s Obj.HospID=HospID
	s Obj.ModuleRowID=ModuleRowID
	s Obj.Type=Type
	s Obj.TypeValue=TypeValue
	s DataList=""
	if (ShowMethod'=""){
		x "s JsonAry="_ShowMethod
		s JsonAryObj=##class(DHCDoc.Util.FromXML).Json2Arr(JsonAry.%ToJSON())
		s RowID=0
		for{
			s RowID=$O(^DHCDocProduceModule(ModuleRowID,"I",RowID))
			q:RowID=""
			s ConfigCode=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",1)
			s ConfigDesc=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",2)
			s ConfigType=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",3)
			s ConfigDataType=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",4)
			for i=1:1:JsonAryObj.%Size() {
				s dataObj=JsonAryObj.GetAt(i)
				s Code=dataObj.GetAt("code")	
				s subvalue=dataObj.GetAt("value")
				s ID=dataObj.GetAt("id")	
				if ((ConfigCode=Code)||(ID=ModuleRowID_"||"_RowID)){s Value=subvalue}
			}
			if (DataList=""){
				s DataList=ConfigCode_$C(1)_ModuleRowID_"||"_RowID_$C(1)_ConfigType_$C(1)_Value
			}else{
				s DataList=DataList_$C(2)_ConfigCode_$C(1)_ModuleRowID_"||"_RowID_$C(1)_ConfigType_$C(1)_Value	
			}
		}
		}
	q DataList
}

ClassMethod ShowProduceModuleValueType(ModuleRowID, HospID, Type, TypeValue)
{
	n (ModuleRowID, HospID, Type, TypeValue)
	if (ModuleRowID["M") s ModuleRowID=$P(ModuleRowID,"M",2)
	if (ModuleRowID["S") s ModuleRowID=$P(ModuleRowID,"S",2)
	s DataList=""
	s RowID=0
	for{
		s RowID=$O(^DHCDocProduceModule(ModuleRowID,"I",RowID))
		q:RowID=""
		s ConfigCode=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",1)
		s ConfigDesc=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",2)
		s ConfigType=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",3)
		s ConfigDataType=$P(^DHCDocProduceModule(ModuleRowID,"I",RowID),"^",4)
		s SubNote=Type_"_"_TypeValue
		s Value=..%GetConfig1(ConfigCode,SubNote,HospID)
		if (DataList=""){
			s DataList=ConfigCode_$C(1)_ModuleRowID_"||"_RowID_$C(1)_ConfigType_$C(1)_Value
		}else{
			s DataList=DataList_$C(2)_ConfigCode_$C(1)_ModuleRowID_"||"_RowID_$C(1)_ConfigType_$C(1)_Value	
		}
	}
	q DataList
}

}
