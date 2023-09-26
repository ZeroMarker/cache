//UDHCOEOrderSaveToTemplate.js
document.body.onload = BodyLoadHandler;
var saveToUser=""
var itemdataDelim = String.fromCharCode(4);
var groupitemDelim = String.fromCharCode(28);
var tabgroupDelim = String.fromCharCode(1);
var AddTOArcosARCIMDatas
var XCONTEXT
var selGroupDesc="";
function BodyLoadHandler(){
	var TemplCategoryobj=document.getElementById("TemplCategory");
	if (TemplCategoryobj){
		TemplCategoryobj.onchange=TemplCategoryChangeHandler;
		TemplCategoryobj.multiple=false;
		TemplCategoryobj.size=1
		TemplCategoryobj.options[TemplCategoryobj.length] = new Option("个人","User.SSUser");
		var GroupID = session['LOGON.GROUPID'];
	    var MenuName = "System.OEOrder.OrgFav.Save.SetSaveForLocation";
	    var ret = tkMakeServerCall("web.DHCDocOrderCommon","IsHaveMenuAuthOrderOrgFav",GroupID, MenuName);
	    if (ret=="1"){
			TemplCategoryobj.options[TemplCategoryobj.length] = new Option("科室","User.CTLoc");
		}
	}	
	//TemplCategory
	XCONTEXT=document.getElementById("XCONTEXT").value
    var obj = window.dialogArguments;
    AddTOArcosARCIMDatas=obj.name;
	//AddTOArcosARCIMDatas=document.getElementById("AddTOArcosARCIMDatas").value
	//alert(unescape(AddTOArcosARCIMDatas))
	//条件
	var Conditionesobj=document.getElementById("Conditiones");
	if (Conditionesobj) {
		Conditionesobj.multiple=false;
		Conditionesobj.size=1
	}
	InitConditiones();
	var csubobj=document.getElementById("SubCategory");
	if (csubobj) {
		csubobj.multiple=false;
		csubobj.size=1
	}
	var cobj=document.getElementById("Category");
	if (cobj) {
		cobj.onchange=CategoryChangeHandler;
		cobj.multiple=false;
		cobj.size=1
		var NewIndex=cobj.length;
		cobj.options[NewIndex] = new Option("","");
		var GetPrescList=document.getElementById("GetCategoryList")
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if (encmeth!="") {
			if (cspRunServerMethod(encmeth,'SetCategoryList')!='0') {}
		}
		for(var j=0;j<cobj.length;j++){
			if (cobj.options[j].text=="医嘱套"){
				cobj.selectedIndex=j;
				CategoryChangeHandler();
				cobj.disabled=true;
				for(var i=0;i<csubobj.length;i++){
					if (csubobj.options[i].text==t['C_PersonOrderset']){
						csubobj.selectedIndex=i;
						//csubobj.disabled=true;
						break;
					}
				}
				break;
			}
		}
	}
	var Code=document.getElementById("Code")
	if (Code) Code.disabled=true
	var ARCOSName=document.getElementById("ARCOSName")
	if (ARCOSName) ARCOSName.onchange=ARCOSName_ChangeHandle;
	var Save=document.getElementById("Save")
	if (Save) Save.onclick=Save_click;

	//btn
	var SaveAddTabNameobj=document.getElementById("SaveAddTabName")
	if (SaveAddTabNameobj) SaveAddTabNameobj.onclick=SaveAddTabNameclick;
	var SaveAddGroupDescobj=document.getElementById("SaveAddGroupDesc")
	if (SaveAddGroupDescobj) SaveAddGroupDescobj.onclick=SaveAddGroupDescclick;
	//btn
	
	//checkbox
	
	var NewARCOS=document.getElementById("NewARCOS")
	if (NewARCOS) NewARCOS.onclick=NewARCOSclick;
	
	//checkbox
	ResetButton(0);
	ResetButton(2);
	ReadTabDesc("User.SSUser")
	var obj=document.getElementById('TabDesc');
	//因为dhtmlXComboFromSelect要判断isDefualt属性,
	if (obj) obj.setAttribute("isDefualt","true");
	combo_TabDesc=dhtmlXComboFromSelect("TabDesc");
	
	if (combo_TabDesc) {
		combo_TabDesc.enableFilteringMode(true);
		combo_TabDesc.selectHandle=combo_TabDescKeydownHandler;
	}
	
	var obj=document.getElementById('GroupDesc');
	//因为dhtmlXComboFromSelect要判断isDefualt属性,
	if (obj) obj.setAttribute("isDefualt","true");
	combo_GroupDesc=dhtmlXComboFromSelect("GroupDesc");
	
	if (combo_GroupDesc) {
		combo_GroupDesc.enableFilteringMode(true);
		combo_GroupDesc.selectHandle=combo_GroupDescKeydownHandler;
	}
	combo_TabDescKeydownHandler()
	CheckSaveToTemplate();
	var BtnAddTabName=document.getElementById("BtnAddTabName")
	if (BtnAddTabName) {
		BtnAddTabName.style.displayed=""
		BtnAddTabName.onclick=BtnAddTabNameclick;
	}
	var btnAddGroupDesc=document.getElementById("btnAddGroupDesc")
	if (btnAddGroupDesc) {
		btnAddGroupDesc.style.displayed=""
		btnAddGroupDesc.onclick=btnAddGroupDescclick;
	}
}
function NewARCOSclick(){
	ResetButton(3)
}
function CheckSaveToTemplate(){
	var SaveToTemplateobj=document.getElementById("SaveToTemplate")
	if (SaveToTemplateobj){
		if (SaveToTemplateobj.checked==true){
			var TabDesc=document.getElementById("TabDesc")
				if (TabDesc) TabDesc.disabled=false
				var GroupDesc=document.getElementById("GroupDesc")
				if (GroupDesc) GroupDesc.disabled=false
			}else{
				var TabDesc=document.getElementById("TabDesc")
				if (TabDesc) TabDesc.disabled=true
				var GroupDesc=document.getElementById("GroupDesc")
				if (GroupDesc) GroupDesc.disabled=true
			}
	}
}
function Wait(){
}
function OrderItemLookupSelect(text){
	//$.messager.alert("警告",text);
	var Split_Value=text.split("^");		
	var idesc=Split_Value[0];
	var icode=Split_Value[1];
	var ARCOS=document.getElementById("ARCOS")
	if (ARCOS){
		ARCOS.value=idesc
		var OldArcosRowid=document.getElementById("OldArcosRowid")
		if (OldArcosRowid) OldArcosRowid.value=icode
	}
	ResetButton(1)
	//alert("2")
}
function SetValue(name,value){
	var obj=document.getElementById(name);
	if (obj) {
		if (obj.tagName=="LABEL") {obj.innerText=value;} else {obj.value=value}
	}
}
function InitConditiones()
{   
	var DocMedUnit=""
	var ForPower
	var obj=document.getElementById("DocMedUnit");
	if(obj) DocMedUnit=obj.value;
	DHCWebD_ClearAllListA("Conditiones"); 
	var encmeth=DHCWebD_GetObjValue("GetConditiones"); 
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","Conditiones",ForPower,DocMedUnit);
		var conditions=document.getElementById("Conditiones");
		var searchConditions=document.getElementById("SearchConditiones");
		for (var i=0;i<conditions.length;i++){
		  if  ((searchConditions)&&(conditions.options[i].value==searchConditions.value)) {
			  conditions.value=conditions.options[i].value;
			  break;
		  }		  
		}
	
	}
}
function CategoryChangeHandler(){
	var List=document.getElementById("Category");
	var selIndex=List.selectedIndex;
	if (selIndex==-1) return;
	var CatID=List.options[selIndex].value;
	if (CatID=="") return;
	var NewIndex=List.length;
	List.options[NewIndex] = new Option("","");
	SetSubCategory(CatID);
}
function SetCategoryList(text,value){
	var obj=document.getElementById("Category");
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
		if (text=="医嘱套") DefaultCatID=value;
	}
}
function SetSubCategory(CatID){
	var obj=document.getElementById("SubCategory");
	if (obj){
		ClearAllList(obj);
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option("","");
		var GetPrescList=document.getElementById("GetSubCategoryList")
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if (encmeth!="") {
			if (cspRunServerMethod(encmeth,'SetSubCategoryList',CatID)!='0') {
			}
		}
	}
}
function SetSubCategoryList(text,value){
	var obj=document.getElementById("SubCategory");
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
	}
}
function CategoryChangeHandler(){
	var List=document.getElementById("Category");
	var selIndex=List.selectedIndex;
	if (selIndex==-1) return;
	var CatID=List.options[selIndex].value;
	if (CatID=="") return;
	var NewIndex=List.length;
	List.options[NewIndex] = new Option("","");
	SetSubCategory(CatID);
}
function ARCOSName_ChangeHandle()
{
	var ARCOSNameObj=document.getElementById("ARCOSName")
	var ARCOSName=ARCOSNameObj.value
	var alias=tkMakeServerCall("ext.util.String","ToChineseSpell",ARCOSName)
	var obj=document.getElementById("ARCOSAlias")
	if (obj){
		obj.value=alias
	}
}
function Save_click(){
    var TabDesc="" //,GroupDesc=""
	var TabDesc=document.getElementById("TabDesc").value
	if (combo_TabDesc) TabDesc=combo_TabDesc.getSelectedValue();
	//var GroupDesc=document.getElementById("GroupDesc").value
	//if (combo_GroupDesc) GroupDesc=combo_GroupDesc.getSelectedValue();
	var Guser=session['LOGON.USERID']
	var OldArcosRowid=document.getElementById("OldArcosRowid").value
	var ARCOSDesc=""
	var obj=document.getElementById("ARCOSName");
	if (obj) var ARCOSDesc=obj.value;
    if ((selGroupDesc=="")&&(OldArcosRowid=="")&&(ARCOSDesc=="")){
      	dhcsys_alert("请选择医嘱套或模板子表")
		return;
    }
	//确保是选择状态再去取值
	var OldArcosRowid=document.getElementById("OldArcosRowid").value
	var Codeobj=document.getElementById("Code");
	var ARCOSNameobj=document.getElementById("ARCOSName");
	var ARCOSAliasobj=document.getElementById("ARCOSAlias");
	if (((OldArcosRowid=="")||(OldArcosRowid=="undefined")||(OldArcosRowid=="null"))&&(Codeobj.style.display=="none")){
		if (!SingleSaveToTemplate()) return false;
		window.close();
		return;
	}

	if ((OldArcosRowid=="")||(OldArcosRowid=="undefined")||(OldArcosRowid=="null")){
		var ConditionesValue=""
		var ConditionesDesc=""	
		var obj=document.getElementById("Conditiones");
		if (obj.selectedIndex!=-1){
		ConditionesValue=obj.options[obj.selectedIndex].value;
		ConditionesDesc=obj.options[obj.selectedIndex].text;
		}
		if (ConditionesValue=="")
		{	dhcsys_alert("请选择条件")
			websys_setfocus('Conditiones');
			return;
		}
		var obj=document.getElementById("Code");
		if (obj) var ARCOSCode=obj.value;

		var obj=document.getElementById("ARCOSName");
		if (obj) var ARCOSDesc=obj.value;
		if (ARCOSDesc=='') {
			dhcsys_alert("医嘱套名称不能为空");
			websys_setfocus('Desc');
			return;
		}
		var obj=document.getElementById("ARCOSAlias");
		if (obj) var ARCOSAlias=obj.value;
		if (ARCOSAlias=='') {
			dhcsys_alert('别名不存在');
			websys_setfocus('Alias');
			return;
		}
	
		var ARCOSCat="";
		var obj=document.getElementById("Category");
		if (obj) {
			ARCOSCatID=obj.value;
			if (obj.selectedIndex!=-1) ARCOSCat=obj.options[obj.selectedIndex].text;
		}
		
		var ARCOSSubCat="";
		var obj=document.getElementById("SubCategory");
		if (obj) {
			var ARCOSSubCatID=obj.value;
			if (obj.selectedIndex!=-1) ARCOSSubCat=obj.options[obj.selectedIndex].text;
		}
		if (ARCOSSubCat==""){
			dhcsys_alert('请选择医嘱套子类');
			websys_setfocus('SubCategory');
			return;
		}
		var ARCOSEffDateFrom=""
		var obj=document.getElementById("StartDate");
		if (obj) var ARCOSEffDateFrom=obj.value;
		
		var obj=document.getElementById("UserID");
		if (obj) var UserID=obj.value;
	     var UserID=session['LOGON.USERID']
		//插入医嘱套
		var GetPrescList=document.getElementById("InsertARCOS")
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if (encmeth!="") {
			var	ARCOSDesc=session['LOGON.USERCODE']+"-"+ARCOSDesc;
			Guser=session['LOGON.USERID']
			GuserCode=session["LOGON.USERCODE"];
			GroupID=session['LOGON.GROUPID'];
			CTLOCID=session['LOGON.CTLOCID'];
			//取组
			//var obj=document.getElementById("GetDocMedUnit");
			//if (obj) {var dd=obj.value} else {var encmeth=''};
			//var DocMedUnit=cspRunServerMethod(dd,Guser,CTLOCID);
			var DocMedUnit=""
			//默认为个人
			if (ConditionesValue=="")   {ConditionesValue=1}
			if (ConditionesValue=="1") {var UserID=Guser; var FavDepList="";var DocMedUnit="";};
			//科室，全院医嘱套bug修改：暂时不允许code为空
			if (ConditionesValue=="2") 
			{
				var UserID="";
				var FavDepList=CTLOCID;
				var DocMedUnit="";
				if (ARCOSCode=='') {
					dhcsys_alert(t['NoCode']);
					websys_setfocus('Code');
					return;
				}
			}
			if (ConditionesValue=="3") 
			{
				var UserID="";
				var FavDepList="";
				var DocMedUnit="";
				if (ARCOSCode=='') {
					dhcsys_alert(t['NoCode']);
					websys_setfocus('Code');
					return;
				}
			}
			if (ConditionesValue=="4") {var UserID=Guser;var FavDepList="";};
			var ForQueryLocIDObj=document.getElementById("ForQueryLocID");
			
			if ((saveToUser)&&(saveToUser=="SaveToUser")&&(ForQueryLocIDObj.value!=""))   {
				var UserID=Guser; var FavDepList="";var DocMedUnit="";
				var Copyobj=document.getElementById("CopyOrdSet");
				var ret="";
				if  ((Copyobj)&&(SelectedARCOSRowid!="")) {		         
	                var ret=cspRunServerMethod(Copyobj.value,SelectedARCOSRowid,UserID,ARCOSCode+"RS",ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit)					
				}
			}else {
				ret=cspRunServerMethod(encmeth,UserID,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit)
			}
			//alert(ret);
			if (ret=='-1') {
				dhcsys_alert("保存失败"+"  您可能填写了已经使用的代码");
				return;
			}else{
				if ((saveToUser)&&(saveToUser=="SaveToUser")) {
					var ARCOSCode=SelectedARCode+"RS";
					var FavRowid=ret;
					var ARCOSRowid=SelectedARCOSRowid;
				}else {
					var FavRowid=mPiece(ret,String.fromCharCode(1),0);
					var ARCOSRowid=mPiece(ret,String.fromCharCode(1),1);
					var ARCOSCode=mPiece(ret,String.fromCharCode(1),2);
				}
				//alert(ARCOSRowid);
			}
	        if ((FavRowid=="")||(FavRowid==" ")){
		        dhcsys_alert("  您可能填写了已经使用的代码");
				return;
		    }else {
				if (window.name!=""){
					dhcsys_alert("保存医嘱套成功");
				}
			}
			var UserDesc="" ;var DepDesc="";var MedUnitDesc="";
			var TabDesc="" //,GroupDesc=""
	 		var TabDesc=document.getElementById("TabDesc").value
			if (combo_TabDesc) TabDesc=combo_TabDesc.getSelectedValue();
			//var GroupDesc=document.getElementById("GroupDesc").value
			//if (combo_GroupDesc) GroupDesc=combo_GroupDesc.getSelectedValue();
	 
            if ((TabDesc!="")&&(selGroupDesc!="")){
	            var List=document.getElementById("TemplCategory");
				var selIndex=List.selectedIndex;
				if (selIndex==-1) return;
				var ObjectType=List.options[selIndex].value;
				if (ObjectType=="") return;
		        var CTLOCID=session['LOGON.CTLOCID'];
		        var IDStr=tkMakeServerCall("web.DHCUserFavItems","GetUserwebsysPreferencesID",Guser,CTLOCID,XCONTEXT,ObjectType)
		        var Type=document.getElementById("Type").value
		        if (Type=="西药"){
		      		var ID=IDStr.split(",")[1]
		      	}else{
			      	var ID=IDStr.split(",")[2]
			    }
			    if (ID==""){
			        dhcsys_alert("没有找到相关模板的位置，模板保存失败")
			        return false
				 }
			      var TabDesc=document.getElementById("TabDesc").value
			      if (combo_TabDesc) TabDesc=combo_TabDesc.getSelectedValue();
			      //var GroupDesc=document.getElementById("GroupDesc").value
			      //if (combo_GroupDesc) GroupDesc=combo_GroupDesc.getSelectedValue();
			      var ret=tkMakeServerCall("web.DHCUserFavItems","SaveToTemplate",ID,TabDesc,selGroupDesc,ARCOSRowid)
			      if(ret==0){
				      dhcsys_alert("保存到模板成功")
				      }
			      }
    			 var value=ARCOSRowid+"^"+ARCOSCode+"^"+ARCOSDesc+"^"+ARCOSCat+"^"+ARCOSSubCat+"^"+ARCOSEffDateFrom+"^"+ARCOSCatID+"^"+ARCOSSubCatID+"^"+FavRowid+"^"+ARCOSAlias+"^"+UserDesc+"^"+DepDesc+"^"+MedUnitDesc+"^"+ObjectType;
				//lxz  将用模式对话框打开的窗口关闭并返回插入后的值
		
		          if(ARCOSRowid==""){return false}
				  var AddTOArcosARCIMDatasOneArcimArrStr=AddTOArcosARCIMDatas.split(String.fromCharCode(2))
				  var len=AddTOArcosARCIMDatasOneArcimArrStr.length
    
			     for(var i=0;i<len;i++){ 
				    //门诊的已经审核但未收费不会在录入的医嘱套中
				    var AddTOArcosARCIMDatasOneArcimArr=AddTOArcosARCIMDatasOneArcimArrStr[i].split("^")
					var OrderARCIMRowid=AddTOArcosARCIMDatasOneArcimArr[0]
					var OrderPackQty=AddTOArcosARCIMDatasOneArcimArr[1]
					var OrderDoseQty=AddTOArcosARCIMDatasOneArcimArr[2]
					var OrderDoseUOM=AddTOArcosARCIMDatasOneArcimArr[3]
					var OrderFreqRowID=AddTOArcosARCIMDatasOneArcimArr[4]
					var OrderDurRowid=AddTOArcosARCIMDatasOneArcimArr[5]
					var OrderInstrRowID=AddTOArcosARCIMDatasOneArcimArr[6]
					var OrderMasterSeqNo=AddTOArcosARCIMDatasOneArcimArr[7]
					var OrderDepProcNote=AddTOArcosARCIMDatasOneArcimArr[8]
					var OrderPriorRowid=AddTOArcosARCIMDatasOneArcimArr[9]
					var SampleId=AddTOArcosARCIMDatasOneArcimArr[10]
					var OrderPriorRemarks=AddTOArcosARCIMDatasOneArcimArr[12]
					var OrderStageCode=AddTOArcosARCIMDatasOneArcimArr[13]
					var OrderSpeedFlowRate=AddTOArcosARCIMDatasOneArcimArr[14]
		            var OrderFlowRateUnitRowId=AddTOArcosARCIMDatasOneArcimArr[15]
		            var MustEnter="N";
		            var ExpStr=OrderStageCode+"^"+MustEnter+"^"+"";
			        ExpStr=ExpStr+"^"+OrderSpeedFlowRate+"^"+OrderFlowRateUnitRowId;
					
					var ret=tkMakeServerCall('web.DHCARCOrdSets','InsertItem',ARCOSRowid,OrderARCIMRowid,OrderPackQty,OrderDoseQty,OrderDoseUOM,OrderFreqRowID,OrderDurRowid,OrderInstrRowID,OrderMasterSeqNo,OrderDepProcNote,OrderPriorRowid,SampleId,"",OrderPriorRemarks,"",ExpStr);
					
				}
				window.returnValue=value
				window.close();
				return;
		
	   }
}else{
	 var Guser=session['LOGON.USERID']
	 var TabDesc="" //,GroupDesc=""
	 var TabDesc=document.getElementById("TabDesc").value
	 if (combo_TabDesc) TabDesc=combo_TabDesc.getSelectedValue();
	 //var GroupDesc=document.getElementById("GroupDesc").value
	 //if (combo_GroupDesc) GroupDesc=combo_GroupDesc.getSelectedValue();
     if ((TabDesc!="")&&(selGroupDesc!="")){
	     var List=document.getElementById("TemplCategory");
		 var selIndex=List.selectedIndex;
		 if (selIndex==-1) return;
		 var ObjectType=List.options[selIndex].value;
	      var CTLOCID=session['LOGON.CTLOCID'];
	      var IDStr=tkMakeServerCall("web.DHCUserFavItems","GetUserwebsysPreferencesID",Guser,CTLOCID,XCONTEXT,ObjectType)
	      var Type=document.getElementById("Type").value
	      if (Type=="西药"){
		      var ID=IDStr.split(",")[1]
		  }else{
			  var ID=IDStr.split(",")[2]
		  }
	      if (ID==""){
		      dhcsys_alert("没有找到相关模板的位置，模板保存失败")
		      return false
		  }
	      var TabDesc=document.getElementById("TabDesc").value
	      if (combo_TabDesc) TabDesc=combo_TabDesc.getSelectedValue();
	      //var GroupDesc=document.getElementById("GroupDesc").value
	      //if (combo_GroupDesc) GroupDesc=combo_GroupDesc.getSelectedValue();
	      var ret=tkMakeServerCall("web.DHCUserFavItems","SaveToTemplate",ID,TabDesc,selGroupDesc,OldArcosRowid)
	      if(ret==0){
		      dhcsys_alert("保存到模板成功")
		  }
	  }
	//var value=ARCOSRowid+"^"+ARCOSCode+"^"+ARCOSDesc+"^"+ARCOSCat+"^"+ARCOSSubCat+"^"+ARCOSEffDateFrom+"^"+ARCOSCatID+"^"+ARCOSSubCatID+"^"+FavRowid+"^"+ARCOSAlias+"^"+UserDesc+"^"+DepDesc+"^"+MedUnitDesc;
	//lxz  将用模式对话框打开的窗口关闭并返回插入后的值
	var ARCOSRowid=OldArcosRowid
	if(ARCOSRowid==""){return false}
     //var rowids=$('#Order_DataGrid').getDataIDs();
     var AddTOArcosARCIMDatasOneArcimArrStr=AddTOArcosARCIMDatas.split(String.fromCharCode(2))
     var len=AddTOArcosARCIMDatasOneArcimArrStr.length
     for(var i=0;i<len;i++){ 
	    //门诊的已经审核但未收费不会在录入的医嘱套中
	    var AddTOArcosARCIMDatasOneArcimArr=AddTOArcosARCIMDatasOneArcimArrStr[i].split("^")
		var OrderARCIMRowid=AddTOArcosARCIMDatasOneArcimArr[0]
		var OrderPackQty=AddTOArcosARCIMDatasOneArcimArr[1]
		var OrderDoseQty=AddTOArcosARCIMDatasOneArcimArr[2]
		var OrderDoseUOM=AddTOArcosARCIMDatasOneArcimArr[3]
		var OrderFreqRowID=AddTOArcosARCIMDatasOneArcimArr[4]
		var OrderDurRowid=AddTOArcosARCIMDatasOneArcimArr[5]
		var OrderInstrRowID=AddTOArcosARCIMDatasOneArcimArr[6]
		var OrderMasterSeqNo=AddTOArcosARCIMDatasOneArcimArr[7]
		var OrderDepProcNote=AddTOArcosARCIMDatasOneArcimArr[8]
		var OrderPriorRowid=AddTOArcosARCIMDatasOneArcimArr[9]
		var SampleId=AddTOArcosARCIMDatasOneArcimArr[10]
		var OrderPriorRemarks=AddTOArcosARCIMDatasOneArcimArr[12]
		var OrderStageCode=AddTOArcosARCIMDatasOneArcimArr[13]
		var OrderSpeedFlowRate=AddTOArcosARCIMDatasOneArcimArr[14]
        var OrderFlowRateUnitRowId=AddTOArcosARCIMDatasOneArcimArr[15]
        var MustEnter="N";
        var ExpStr=OrderStageCode+"^"+MustEnter+"^"+"";
        ExpStr=ExpStr+"^"+OrderSpeedFlowRate+"^"+OrderFlowRateUnitRowId;
		var ret=tkMakeServerCall('web.DHCARCOrdSets','InsertItem',ARCOSRowid,OrderARCIMRowid,OrderPackQty,OrderDoseQty,OrderDoseUOM,OrderFreqRowID,OrderDurRowid,OrderInstrRowID,OrderMasterSeqNo,OrderDepProcNote,OrderPriorRowid,SampleId,"",OrderPriorRemarks,"",ExpStr);
		
	 }
		dhcsys_alert("保存到医嘱套成功")
		var value=""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+ObjectType;
		window.returnValue=value
		window.close();
		return;
	}
}
function ResetButton(type)
{
	if (type==0){
		var AddTabName=document.getElementById("AddTabName")
		if (AddTabName) AddTabName.style.display="none"
		var cAddTabName=document.getElementById("cAddTabName")
		if (cAddTabName) cAddTabName.style.display="none"
		var SaveAddTabName=document.getElementById("SaveAddTabName")
		if (SaveAddTabName) SaveAddTabName.style.display="none"
		var AddGroupDesc=document.getElementById("AddGroupDesc")
		if (AddGroupDesc) AddGroupDesc.style.display="none"
		var cAddGroupDesc=document.getElementById("cAddGroupDesc")
		if (cAddGroupDesc) cAddGroupDesc.style.display="none"
		var SaveAddGroupDesc=document.getElementById("SaveAddGroupDesc")
		if (SaveAddGroupDesc) SaveAddGroupDesc.style.display="none"
		
    }
	if (type==1){
		var csubobj=document.getElementById("SubCategory");
		if (csubobj) {csubobj.disabled="true"}
		var ARCOSName=document.getElementById("ARCOSName");
		if (ARCOSName) ARCOSName.disabled="true"
		var ARCOSAlias=document.getElementById("ARCOSAlias");
		if (ARCOSAlias) ARCOSAlias.disabled="true"
		var Conditiones=document.getElementById("Conditiones");
		if (Conditiones) Conditiones.disabled="true"
	}
	if (type==2){
		var Category=document.getElementById("Category")
		if (Category) Category.style.display="none"
		var cCategory=document.getElementById("cCategory")
		if (cCategory) cCategory.style.display="none"
		var SubCategory=document.getElementById("SubCategory")
		if (SubCategory) SubCategory.style.display="none"
		var cSubCategory=document.getElementById("cSubCategory")
		if (cSubCategory) cSubCategory.style.display="none"
		var ARCOSName=document.getElementById("ARCOSName")
		if (ARCOSName) ARCOSName.style.display="none"
		var cARCOSName=document.getElementById("cARCOSName")
		if (cARCOSName) cARCOSName.style.display="none"
		var Code=document.getElementById("Code")
		if (Code) Code.style.display="none"
		var cCode=document.getElementById("cCode")
		if (cCode) cCode.style.display="none"
		var ARCOSAlias=document.getElementById("ARCOSAlias")
		if (ARCOSAlias) ARCOSAlias.style.display="none"
		var cARCOSAlias=document.getElementById("cARCOSAlias")
		if (cARCOSAlias) cARCOSAlias.style.display="none"
		var Conditiones=document.getElementById("Conditiones")
		if (Conditiones) Conditiones.style.display="none"
		var cConditiones=document.getElementById("cConditiones")
		if (cConditiones) cConditiones.style.display="none"
		
	}
	if (type==3){
		var Category=document.getElementById("Category")
		if (Category) Category.style.display=""
		var cCategory=document.getElementById("cCategory")
		if (cCategory) cCategory.style.display=""
		var SubCategory=document.getElementById("SubCategory")
		if (SubCategory) SubCategory.style.display=""
		var cSubCategory=document.getElementById("cSubCategory")
		if (cSubCategory) cSubCategory.style.display=""
		var ARCOSName=document.getElementById("ARCOSName")
		if (ARCOSName) ARCOSName.style.display=""
		var cARCOSName=document.getElementById("cARCOSName")
		if (cARCOSName) cARCOSName.style.display=""
		var Code=document.getElementById("Code")
		if (Code) Code.style.display=""
		var cCode=document.getElementById("cCode")
		if (cCode) cCode.style.display=""
		var ARCOSAlias=document.getElementById("ARCOSAlias")
		if (ARCOSAlias) ARCOSAlias.style.display=""
		var cARCOSAlias=document.getElementById("cARCOSAlias")
		if (cARCOSAlias) cARCOSAlias.style.display=""
		var Conditiones=document.getElementById("Conditiones")
		if (Conditiones) Conditiones.style.display=""
		var cConditiones=document.getElementById("cConditiones")
		if (cConditiones) cConditiones.style.display=""
		
	}
	if (type==4){
		var AddTabName=document.getElementById("AddTabName")
		if (AddTabName) AddTabName.style.display="none"
		var cAddTabName=document.getElementById("cAddTabName")
		if (cAddTabName) cAddTabName.style.display="none"
		var SaveAddTabName=document.getElementById("SaveAddTabName")
		if (SaveAddTabName) SaveAddTabName.style.display="none"
	}
	if (type==5){
		var AddGroupDesc=document.getElementById("AddGroupDesc")
		if (AddGroupDesc) AddGroupDesc.style.display="none"
		var cAddGroupDesc=document.getElementById("cAddGroupDesc")
		if (cAddGroupDesc) cAddGroupDesc.style.display="none"
		var SaveAddGroupDesc=document.getElementById("SaveAddGroupDesc")
		if (SaveAddGroupDesc) SaveAddGroupDesc.style.display="none"
	}
}
function SaveAddTabNameclick()
{
	var AddTabName=document.getElementById("AddTabName").value
	if (AddTabName==""){
		dhcsys_alert("模板组描述不能为空")
		return
	}
	///w ##class(web.DHCUserFavItems).AddTabName(79,"西药","2017")
	var UserID=session['LOGON.USERID']
	var Type=DHCC_GetElementData("Type")
	var CTLOCID=session['LOGON.CTLOCID'];
	var List=document.getElementById("TemplCategory");
	var selIndex=List.selectedIndex;
	if (selIndex==-1) return;
	var ObjectType=List.options[selIndex].value;
	for (var k=0;k<combo_TabDesc.optionsArr.length;k++){
		if (combo_TabDesc.optionsArr[k].text==AddTabName){
			alert(AddTabName+" 已存在!");
			websys_setfocus('AddTabName');
			return false;
		}
	}
	var ret=tkMakeServerCall("web.DHCUserFavItems","AddTabName",UserID,Type,AddTabName,CTLOCID,XCONTEXT,ObjectType)
	if (ret==0){
		dhcsys_alert("增加成功")
		ResetButton(4)
	}else{
		dhcsys_alert("增加失败")
	}
	var UserID=session['LOGON.USERID']
	var Type=DHCC_GetElementData("Type")
	if (combo_TabDesc){
		combo_TabDesc.clearAll();
		combo_TabDesc.setComboText("");
		var UserID=session['LOGON.USERID']
		var CTLOCID=session['LOGON.CTLOCID'];
	    var Type=DHCC_GetElementData("Type");
		var TabNameString=tkMakeServerCall("web.DHCUserFavItems","GetTabNameString",UserID,Type,CTLOCID,XCONTEXT,ObjectType)
		if (TabNameString!=""){
	        var Arr=DHCC_StrToArray(TabNameString);
			combo_TabDesc.addOption(Arr);
			combo_TabDesc.setComboValue(AddTabName)
			combo_TabDescKeydownHandler()
		}
	}	
}
function SaveAddGroupDescclick()
{
	var AddGroupDesc=document.getElementById("AddGroupDesc").value
	var TabDesc=combo_TabDesc.getSelectedValue();
	var UserID=session['LOGON.USERID']
	var CTLOCID=session['LOGON.CTLOCID'];
	var Type=DHCC_GetElementData("Type")
	if (TabDesc==""){
		dhcsys_alert("请先选择要加入的模板组")
	}
	var List=document.getElementById("TemplCategory");
	var selIndex=List.selectedIndex;
	if (selIndex==-1) return;
	var ObjectType=List.options[selIndex].value;
	var ret=tkMakeServerCall("web.DHCUserFavItems","AddGroupDesc",UserID,Type,TabDesc,AddGroupDesc,CTLOCID,XCONTEXT,ObjectType)
	if (ret==0){
		dhcsys_alert("增加成功")
		ResetButton(5)
	}else{
		dhcsys_alert("增加失败"+ret)
	}
	combo_TabDescKeydownHandler()
}
function BtnAddTabNameclick()
{
	var AddTabName=document.getElementById("AddTabName")
	if (AddTabName) {
		AddTabName.style.display=""
		AddTabName.value=""
	}
	var cAddTabName=document.getElementById("cAddTabName")
	if (cAddTabName) cAddTabName.style.display=""
	var SaveAddTabName=document.getElementById("SaveAddTabName")
	if (SaveAddTabName) SaveAddTabName.style.display=""
}
function btnAddGroupDescclick()
{
    var AddGroupDesc=document.getElementById("AddGroupDesc")
	if (AddGroupDesc) {
		AddGroupDesc.style.display="";
		AddGroupDesc.value="";
	}
	var cAddGroupDesc=document.getElementById("cAddGroupDesc")
	if (cAddGroupDesc) cAddGroupDesc.style.display=""
	var SaveAddGroupDesc=document.getElementById("SaveAddGroupDesc")
	if (SaveAddGroupDesc) SaveAddGroupDesc.style.display=""
	   
}
function TemplCategoryChangeHandler(){
	var List=document.getElementById("TemplCategory");
	var selIndex=List.selectedIndex;
	if (selIndex==-1) return;
	var ObjectType=List.options[selIndex].value;
	if (ObjectType=="") return;
	if (combo_TabDesc){
		combo_TabDesc.clearAll();
		combo_TabDesc.setComboText("");
		combo_GroupDesc.clearAll();
		combo_GroupDesc.setComboText("");
		var UserID=session['LOGON.USERID']
		var CTLOCID=session['LOGON.CTLOCID'];
	    var Type=DHCC_GetElementData("Type");
		var TabNameString=tkMakeServerCall("web.DHCUserFavItems","GetTabNameString",UserID,Type,CTLOCID,XCONTEXT,ObjectType)
		if (TabNameString!=""){
	        var Arr=DHCC_StrToArray(TabNameString);
			combo_TabDesc.addOption(Arr);
			combo_TabDesc.setComboValue(AddTabName)
			combo_TabDescKeydownHandler()
		}
	}else{
		ReadTabDesc(ObjectType);
	}
}
function ReadTabDesc(ObjectType){
	DHCC_ClearList("TabDesc");
	var UserID=session['LOGON.USERID']
	var Type=DHCC_GetElementData("Type")
	var CTLOCID=session['LOGON.CTLOCID'];
	var encmeth=DHCC_GetElementData("TabNameEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","TabDesc",UserID,Type,CTLOCID,XCONTEXT,ObjectType);
	}
}
function ReadGroupDesc(){
	DHCC_ClearList("combo_GroupDesc");
	var UserID=session['LOGON.USERID']
	var Type=DHCC_GetElementData("Type")
	var TabDesc=combo_TabDesc.getSelectedValue()
	var List=document.getElementById("TemplCategory");
	var selIndex=List.selectedIndex;
	if (selIndex==-1) return;
	var ObjectType=List.options[selIndex].value;
	if (ObjectType=="") return;
	var encmeth=DHCC_GetElementData("GroupDescEncrypt");
	var CTLOCID=session['LOGON.CTLOCID'];
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","GroupDesc",UserID,Type,TabDesc,CTLOCID,XCONTEXT,ObjectType);
	}
}
function combo_TabDescKeydownHandler()
{
	var List=document.getElementById("TemplCategory");
	var selIndex=List.selectedIndex;
	if (selIndex==-1) return;
	var ObjectType=List.options[selIndex].value;
	if (ObjectType=="") return;
	if (combo_GroupDesc){
		combo_GroupDesc.clearAll();
		combo_GroupDesc.setComboText("");
		selGroupDesc="";
		var TabDesc=combo_TabDesc.getSelectedValue()
		//combo_GroupDesc.addOption('');
		var UserID=session['LOGON.USERID']
	    var Type=DHCC_GetElementData("Type")
	    var CTLOCID=session['LOGON.CTLOCID'];
	    //ReadGroupDesc();
		var GroupDescStr=tkMakeServerCall("web.DHCUserFavItems","GetGroupDescString",UserID,Type,TabDesc,CTLOCID,XCONTEXT,ObjectType)
		if (GroupDescStr!=""){
			var Arr=DHCC_StrToArray(GroupDescStr);
			combo_GroupDesc.addOption(Arr);
		}
		
	}	
}
function combo_GroupDescKeydownHandler(e)
{
	selGroupDesc=document.getElementById("GroupDesc").value
	if (combo_GroupDesc) selGroupDesc=combo_GroupDesc.getSelectedValue();
}
function SingleSaveToTemplate(){
	var UserDesc="" ;var DepDesc="";var MedUnitDesc="";
	var TabDesc="" //,GroupDesc=""
	var TabDesc=document.getElementById("TabDesc").value
	if (combo_TabDesc) TabDesc=combo_TabDesc.getSelectedValue();
	//var GroupDesc=document.getElementById("GroupDesc").value
	//if (combo_GroupDesc) GroupDesc=combo_GroupDesc.getSelectedValue();
	var Guser=session['LOGON.USERID']
    if ((TabDesc!="")&&(selGroupDesc!="")){
	    var List=document.getElementById("TemplCategory");
		var selIndex=List.selectedIndex;
		if (selIndex==-1) return;
		var ObjectType=List.options[selIndex].value;
		if (ObjectType=="") return;
	      var CTLOCID=session['LOGON.CTLOCID'];
	      var IDStr=tkMakeServerCall("web.DHCUserFavItems","GetUserwebsysPreferencesID",Guser,CTLOCID,XCONTEXT,ObjectType)
	      var Type=document.getElementById("Type").value
	      if (Type=="西药"){
		      var ID=IDStr.split(",")[1]
		  }else{
			  var ID=IDStr.split(",")[2]
		  }
		  if (ID==""){
		      dhcsys_alert("没有找到相关模板的位置，模板保存失败")
		      return false
		  }
	      //var TabDesc=document.getElementById("TabDesc").value
	      //if (combo_TabDesc) TabDesc=combo_TabDesc.getSelectedValue();
	      //var GroupDesc=document.getElementById("GroupDesc").value
	      //if (combo_GroupDesc) GroupDesc=combo_GroupDesc.getSelectedValue();
	      var AddTOArcosARCIMDatasOneArcimArrStr=AddTOArcosARCIMDatas.split(String.fromCharCode(2))
          var len=AddTOArcosARCIMDatasOneArcimArrStr.length
          if (len<1) return;
          for(var i=0;i<len;i++){ 
		    //门诊的已经审核但未收费不会在录入的医嘱套中
		    var AddTOArcosARCIMDatasOneArcimArr=AddTOArcosARCIMDatasOneArcimArrStr[i].split("^")
			var OrderARCIMRowid=AddTOArcosARCIMDatasOneArcimArr[0]
	        var ret=tkMakeServerCall("web.DHCUserFavItems","SaveToTemplate",ID,TabDesc,selGroupDesc,OrderARCIMRowid,"ARCIM")
	        if (ret!=0){
		        dhcsys_alert(ret.split("^")[1])
		        return false;
		    }
          }
	      if(ret==0){
		      dhcsys_alert("保存到模板成功")
		      var value=""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+ObjectType;
		      window.returnValue=value
		      return true;
		  }
	 }
}