var PageLogicObj={
	isLocChange:"",
	isDocChange:"",
	m_DoctorDataGrid:"",
};
$(function(){
	Init();
	InitEvent();
	
});
function Init(){
	//初始化医院
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		ClearData();
		ClearDataNew();
		InitLoc();
		InitDoc();
		LoadDoctorDataGridData("","");
		InitTimeRange();
		InitRESSessionType();
		InitRESClinicGroup();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitCombo();
		PageLogicObj.m_DoctorDataGrid=InitDoctorDataGrid();
		LoadDoctorDataGridData();
	}
}
$(window).load(function() {
})

function InitDoctorDataGrid(){
	var Columns=[[ 
		{field:'RowID',hidden:true,title:''},
		{field:'Desc',title:'描述',width:30},
    ]]
	var DoctorDataGrid=$("#TabDoctor").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 15,
		pageList : [15,50,100],
		idField:'RowID',
		columns :Columns,
		onSelect:function(index, row){
			DoctorRowChangeHandle(row);	
		},
		onBeforeSelect:function(index, row){
			/*var selrow=PageLogicObj.m_DoctorDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_DoctorDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_DoctorDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}*/
		}
	}); 
	return DoctorDataGrid;	
}

function LoadDoctorDataGridData(LocID,DocID){
	var Type="Loc";
	if(LocID!=""){
		var Type="Loc";
		var InputID=LocID;
	}
	if (DocID!=""){
		var Type="Doc";
		var InputID=DocID; 
	}
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.cm({
	    ClassName : "web.DHCRBResource",
	    QueryName : "FindResLocOrDoc",
	    InputID:InputID,
	    Type:Type,
	    UserID:"",
	    HospID:HospID,
	    Pagerows:PageLogicObj.m_DoctorDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_DoctorDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		PageLogicObj.m_DoctorDataGrid.datagrid('clearSelections'); 
		PageLogicObj.m_DoctorDataGrid.datagrid('clearChecked'); 
	});	
}

function InitEvent(){
	$('#BtnUpdate').click(function() {
		UpdateClickHandle();	
	})
	$('#BtnUpdateNew').click(function() {
		UpdateNewClickHandle();		
	})
	//改为datagrid
	/*$('#List_Doctor').change(function(){
		ListDoctorChangeHandle();	
	});*/
	
	$(document.body).bind("keydown",BodykeydownHandler)
}

function InitCombo(){
	InitLoc();
	InitDoc("");
	InitTimeRange();
	InitRESSessionType();
	InitRESClinicGroup();
}

function InitLoc(){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
    $.cm({
		ClassName:"web.DHCRBResSession",
		QueryName:"FindLoc",
		Loc:"",
		UserID:session['LOGON.USERID'],
		HospitalDr:HospID,
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#RESCTLOCDR", {
				valueField: 'Hidden',
				textField: 'Desc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return ((row["Desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0));
				},onSelect:function(record){
					PageLogicObj.isLocChange=true;
					PageLogicObj.isDocChange=false;
					//InitDoc(record.rowid);
					var SelText=record.Desc;
					if(SelText.indexOf("-")>-1){SelText=SelText.split("-")[0]}
					$HUI.combobox("#RESCTLOCDR").setText(SelText);
					$HUI.combobox("#MarkCode").setValue("");
					InitRESClinicGroup(record.Hidden);
					//SetResDocList(record.rowid,"");
					LoadDoctorDataGridData(record.Hidden,"");
					ClearData();
					ClearDataNew();
					$HUI.combobox("#TimeRange").setValue("");	
				},onHidePanel:function(){
					var SelText=$HUI.combobox("#RESCTLOCDR").getText();	
					if(SelText.indexOf("-")>-1){SelText=SelText.split("-")[0]}
					$HUI.combobox("#RESCTLOCDR").setText(SelText);
				}
		 });
	});
}

function InitDoc(val){
    var ret=$.cm({
		ClassName:"web.DHCRBResSession",
		MethodName:"GetResDocBroker",
		DepRowId:val,
		Type:"",
		AdmDate:"",
		UserID:"",
		HospID:$HUI.combogrid('#_HospUserList').getValue(),
		Flag:"1", //是否显示未排班的医生：非空-显示
		dataType:"text",
	},false)
	var EditTypeArr=new Array();
	var Dem=String.fromCharCode(1)
	if(ret!=""){
		var retArr=ret.split("^")
		for(var i=0;i<retArr.length;i++){
			var value=retArr[i].split(Dem)[0];
			var desc=retArr[i].split(Dem)[1];
			var onestr = {"value":value, "desc":desc};
			EditTypeArr.push(onestr);	
		}
	}
	$HUI.combobox("#MarkCode",{
		valueField:'value',   
    	textField:'desc',
    	data: EditTypeArr,
		filter: function(q, row){
			return (row["desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},onLoadSuccess:function(){
			var boxvalue=$HUI.combobox("#MarkCode").setValue("");
		},onSelect:function(record){
			PageLogicObj.isLocChange=false;
			PageLogicObj.isDocChange=true;
			//SetResDocList("",record.value)
			var SelText=record.desc;
			if(SelText.indexOf("-")>-1){SelText=SelText.split("-")[0]}
			$HUI.combobox("#MarkCode").setText(SelText);
			LoadDoctorDataGridData("",record.value)	
			$HUI.combobox("#RESCTLOCDR").setValue("");
			ClearData();
			ClearDataNew();
			$HUI.combobox("#TimeRange").setValue("");	
		},onHidePanel:function(){
			var SelText=$HUI.combobox("#MarkCode").getText();	
			if(SelText.indexOf("-")>-1){SelText=SelText.split("-")[0]}
			$HUI.combobox("#MarkCode").setText(SelText);
		}	
	})
}

function InitTimeRange(){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	var ret=$.cm({
		ClassName:"web.DHCRBResSession",
		MethodName:"GetTimeRangeStr",
		HospID:HospID,
		dataType:"text",
	},false)
	var EditTypeArr=new Array();
	var Dem=String.fromCharCode(1)
	if(ret!=""){
		var retArr=ret.split("^")
		for(var i=0;i<retArr.length;i++){
			var value=retArr[i].split(Dem)[0];
			var desc=retArr[i].split(Dem)[1];
			var onestr = {"value":value, "desc":desc};
			EditTypeArr.push(onestr);	
		}
	}
	$HUI.combobox("#TimeRange",{
		valueField:'value',   
    	textField:'desc',
    	data: EditTypeArr,
    	editable:false,
		onLoadSuccess:function(){
			var boxvalue=$HUI.combobox("#TimeRange").setValue("");
		},onSelect:function(record){
			var SelText=record.desc;
			if(SelText.indexOf("-")>-1){SelText=SelText.split("-")[0]}
			$HUI.combobox("#TimeRange").setText(SelText);
			PutTimeRangeselectHandle();	
		},onHidePanel:function(){
			var SelText=$HUI.combobox("#TimeRange").getText();	
			if(SelText.indexOf("-")>-1){SelText=SelText.split("-")[0]}
			$HUI.combobox("#TimeRange").setText(SelText);
		}
	})
}

function InitRESSessionType(){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.cm({
		ClassName:"web.DHCBL.BaseReg.BaseDataQuery",
		QueryName:"RBCSessionTypeQuery",
		HospID:HospID,
		dataType:"json",
		rows:9999
	},function(Data){
		var cbox = $HUI.combobox("#RESSessionType", {
			valueField: 'ID',
			textField: 'Desc', 
			editable:true,
			data: Data["rows"],
			filter: function(q, row){
				return (row["Desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Hidden"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["CTContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onSelect:function(record){
			}
		});
	});	
}

function InitRESClinicGroup(val){
	if (!val) GetClinicGroupStr="";
	var ret=$.cm({
		ClassName:"web.DHCRBResSession",
		MethodName:"GetClinicGroupStr",
		DepRowid:val,
		dataType:"text",
	},false)
	var EditTypeArr=new Array();
	var Dem=String.fromCharCode(1)
	if(ret!=""){
		var retArr=ret.split("^")
		for(var i=0;i<retArr.length;i++){
			var value=retArr[i].split(Dem)[0];
			var desc=retArr[i].split(Dem)[1];
			var onestr = {"value":value, "desc":desc};
			EditTypeArr.push(onestr);	
		}
	}
	$HUI.combobox("#RESClinicGroup",{
		valueField:'value',   
    	textField:'desc',
    	data: EditTypeArr,
    	editable:false,
		onLoadSuccess:function(){
			var boxvalue=$HUI.combobox("#RESClinicGroup").setValue("");
		},onSelect:function(){
				
		}	
	})	
}

//由select box 改为 表格
function SetResDocList(LocID,DocID){
	$("#List_Doctor").empty();
	if(LocID!=""){
		$.cm({
			ClassName:"web.DHCRBResource",
			MethodName:"GetResDocByLocId",
			itmjs:"",
			val:LocID,
			UserID:"",
			JSON:"JSON",
			dataType:"text",	
		},function(objScope){
			if(objScope=="")return;
			var objScopeArr=objScope.split("^");
			var vlist = ""; 
			var selectlist="";
			for(var i=0;i<objScopeArr.length;i++){
				var oneLoc=	objScopeArr[i];
				var oneLocArr=oneLoc.split(String.fromCharCode(1))
				var LocRowID=oneLocArr[0];
				var LocDesc=oneLocArr[1];
				vlist += "<option value=" + LocRowID + ">" + LocDesc + "</option>"; 
			}
			$("#List_Doctor").append(vlist); 
		})
	}
	if(DocID!=""){
		$.cm({
			ClassName:"web.DHCRBResource",
			MethodName:"GetResLocByDocId",
			itmjs:"",
			docId:DocID,
			JSON:"JSON",
			dataType:"text",	
		},function(objScope){
			if(objScope=="")return;
			var objScopeArr=objScope.split("^");
			var vlist = ""; 
			var selectlist="";
			for(var i=0;i<objScopeArr.length;i++){
				var oneLoc=	objScopeArr[i];
				var oneLocArr=oneLoc.split(String.fromCharCode(1))
				var LocRowID=oneLocArr[0];
				var LocDesc=oneLocArr[1];
				vlist += "<option value=" + LocRowID + ">" + LocDesc + "</option>"; 
			}
			$("#List_Doctor").append(vlist); 
			
		})
	}	
}

function UpdateClickHandle(){
	/*if(typeof($("#List_Doctor option:selected").val())=="undefined"){
		$.messager.alert("提示","请选择一个科室医生","info");
	   	return false;		
	}
	var tmp=$("#List_Doctor option:selected").val().split(String.fromCharCode(2));
	var RowID=tmp[0];
	if(RowID==""){
		$.messager.alert("提示","请选择一个科室医生","info");
	   	return false;	
	}*/
	var RowID="";
	var row=PageLogicObj.m_DoctorDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择科室或医生","info");
		return false;
	}
	tmp=row.RowID.split("@");
	var RowID=tmp[0];
	if (!CheckDataValid()) return false;
	var RESSessionType=$HUI.combobox("#RESSessionType").getValue();	
	var RESSessionTypeID=CheckComboxSelData("RESSessionType",RESSessionType);
	var RESClinicGroup=$HUI.combobox("#RESClinicGroup").getValue();	
	var RESClinicGroupID=CheckComboxSelData("RESClinicGroup",RESClinicGroup);
	var RESLoad=$('#RESLoad').numberbox('getValue');
	var RESAppLoad="" //$('#RESAppLoad').numberbox('getValue');
	var RESAppStartNum="" //$('#RESAppStartNum').numberbox('getValue');
	var RESAddLoad=$('#RESAddLoad').numberbox('getValue');
	var RESEPMarkFlag=$HUI.checkbox("#RESEPMarkFlag").getValue();
	if(RESEPMarkFlag){RESEPMarkFlag="Y"}
	else{RESEPMarkFlag="N"}	
	var RESAllowGetSeqNoFlag=$HUI.checkbox("#RESAllowGetSeqNoFlag").getValue();	
	if(RESAllowGetSeqNoFlag){RESAllowGetSeqNoFlag="Y"}
	else{RESAllowGetSeqNoFlag="N"}
	
	var entityInfo=["ID="+RowID,
					"RESClinicGroupDR="+RESClinicGroupID,
					"RESSessionTypeDR="+RESSessionTypeID,
					"RESLoad="+RESLoad, 
					"RESAppLoad="+RESAppLoad, 
					"RESAppStartNum="+RESAppStartNum,
					"RESAddLoad="+RESAddLoad,
					"RESEPMarkFlag="+RESEPMarkFlag,
					"RESAllowGetSeqNoFlag="+RESAllowGetSeqNoFlag
    				];
                
	var resource=Card_GetEntityClassInfoToXML(entityInfo);
	$.cm({
		ClassName:"web.DHCBL.DHCRBResource.DHCRBResourceBuilder",
		MethodName:"DHCRBResourceUpdate",
		RBResourceInfo:resource,
		dataType:"text"	
	},function(rtn){
		if(rtn==0) {
	 		$.messager.show({title:"提示",msg:"全局默认信息修改成功"});
 		}else{
	   		$.messager.alert("提示","全局默认信息修改失败,错误信息:"+rtn,"error");
	   		return false;
   		}
	});
}

function CheckDataValid(){
	var RESSessionType=$HUI.combobox("#RESSessionType").getValue();	
	var RESClinicGroup=$HUI.combobox("#RESClinicGroup").getValue();	
	var RESLoad=$('#RESLoad').numberbox('getValue');
	var RESAppLoad="" //$('#RESAppLoad').numberbox('getValue');
	var RESAppStartNum="" //$('#RESAppStartNum').numberbox('getValue');
	var RESAddLoad=$('#RESAddLoad').numberbox('getValue');
	var RESEPMarkFlag=$HUI.checkbox("#RESEPMarkFlag").getValue();	
	var RESAllowGetSeqNoFlag=$HUI.checkbox("#RESAllowGetSeqNoFlag").getValue();	
	/*if(!isInteger(RESLoad)){
		$.messager.alert("提示","正号限额只能为整数","info");
		return false;
	}
	if(!isInteger(RESAppLoad)){
		$.messager.alert("提示","预约限额只能为整数","info");
		return false;
	}
	if(!isInteger(RESAppStartNum)){
		$.messager.alert("提示","预约起始号只能为整数","info");
		return false;
	}
	if(!isInteger(RESAddLoad)){
		$.messager.alert("提示","加号限额只能为整数","info");
		return false;
	}*/
	//&&(RESAppLoad=="")&&(RESAppStartNum=="")
	if((RESLoad=="")&&(RESAddLoad=="")){
		return true;	
	}
	/*RESLoad=parseInt(RESLoad)
	RESAppLoad=parseInt(RESAppLoad)
	RESAppStartNum=parseInt(RESAppStartNum)
	RESAddLoad=parseInt(RESAddLoad)
	if(isNaN(RESLoad))RESLoad=0;
	if(isNaN(RESAppLoad))RESAppLoad=0;
	if(isNaN(RESAppStartNum))RESAppStartNum=0;
	if(isNaN(RESAddLoad))RESAddLoad=0;
	//alert(RESLoad+","+RESAppStartNum+","+RESAppLoad+","+(RESLoad-RESAppStartNum+1>=RESAppLoad))
	if(!(RESLoad-RESAppStartNum+1>=RESAppLoad)) {
		$.messager.alert("提示",'预约起始号加预约限额不能大于正号限额',"info");
		return false;
	} */
	return true;
}

function isInteger(objStr) {
    var reg = /^\+?[0-9]*[0-9][0-9]*$/;
    var ret = objStr.match(reg);
    if (ret == null) { return false } else { return true }
}

function UpdateNewClickHandle(){
	/*if(typeof($("#List_Doctor option:selected").val())=="undefined"){
		$.messager.alert("提示","请选择一个科室医生","info");
	   	return false;		
	}
	var tmp=$("#List_Doctor option:selected").val().split(String.fromCharCode(2));
	var RowID=tmp[0];
	if(RowID==""){
		$.messager.alert("提示","请选择一个科室医生","info");
	   	return false;	
	}*/
	var RowID="";
	var row=PageLogicObj.m_DoctorDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择科室或医生","info");
		return false;
	}
	tmp=row.RowID.split("@");
	var RowID=tmp[0];
	if (!CheckDataValidNew()) return false;
	var TimeRange=$HUI.combobox("#TimeRange").getValue();
	var TimeRangeRowId=CheckComboxSelData("TimeRange",TimeRange)
	var RESLoad=$('#ResLoadNew').numberbox('getValue');
	var RESAppLoad="" //$('#ResAppLoadNew').numberbox('getValue');
	var ResAppStartNew="" //$('#ResAppStartNew').numberbox('getValue');
	var AutoLoad="";
	var ExtLoad="";
	var Infostr=RowID+"^"+TimeRangeRowId+"^"+RESLoad+"^"+RESAppLoad+"^"+ResAppStartNew+"^"+AutoLoad+"^"+ExtLoad;
	// var returnvalue=cspRunServerMethod(encmeth,RCDRowid,Age,AgeCompare,SexDr,DeptDr,MarkDr,FeeCateDr,PatTypeDr,OldCard);
	$.cm({
		ClassName:"web.DHCRBResource",
		MethodName:"TRRBResourceServerSave",
		Infostr:Infostr,
		dataType:"text"		
	},function(ret){
		if(ret>0) {
	 		$.messager.show({title:"提示",msg:"按时段默认信息修改成功"});
 		}else{
	   		$.messager.alert("提示","修改失败,错误信息:"+ret,"error");
	   		return false;
   		}
	})
}

function CheckDataValidNew(){
	var TimeRange=$HUI.combobox("#TimeRange").getValue();
	var TimeRange=CheckComboxSelData("TimeRange",TimeRange)
	if(TimeRange==""){
		$.messager.alert("提示","请选择时段","info");
	   	return false;
	}
	var RESLoad=$('#ResLoadNew').numberbox('getValue');
	//var RESAppLoad=$('#ResAppLoadNew').numberbox('getValue');
	//var ResAppStartNew=$('#ResAppStartNew').numberbox('getValue');
	
	if((RESLoad=="")){ //&&(RESAppLoad=="")&&(ResAppStartNew=="")
		return true;	
	}
	/*RESLoad=parseInt(RESLoad);
	RESAppLoad=parseInt(RESAppLoad);
	ResAppStartNew=parseInt(ResAppStartNew);
	if(isNaN(RESLoad))RESLoad=0;
	if(isNaN(RESAppLoad))RESAppLoad=0;
	if(isNaN(ResAppStartNew))ResAppStartNew=0;
	//alert(RESLoad+","+RESAppStartNum+","+RESAppLoad+","+(RESLoad-RESAppStartNum+1>=RESAppLoad))
	if(!(RESLoad-ResAppStartNew+1>=RESAppLoad)) {
		$.messager.alert("提示",'预约起始号加预约限额不能大于正号限额',"info");
		return false;
	} */
	return true;
}

function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="RESCTLOCDR"){
			var CombValue=Data[i].rowid;
		 	var CombDesc=Data[i].Desc;
	     }else if(id=="RESSessionType"){
			var CombValue=Data[i].ID  
		 	var CombDesc=Data[i].Desc
	     }else{
			var CombValue=Data[i].value  
		 	var CombDesc=Data[i].desc
	     }
		 if(selId==CombValue){
			 selId=CombValue;
			 Find=1;
			 break;
	     }
	  }
	  if (Find=="1") return selId
	  return "";
}

function DoctorRowChangeHandle(row){
	//var tmp=$("#List_Doctor option:selected").val().split(String.fromCharCode(2));
	var tmp=row.RowID.split("@");
  	if(PageLogicObj.isDocChange){
	  	var DeptID=CheckComboxSelData("RESCTLOCDR",tmp[1]);
 		$HUI.combobox("#RESCTLOCDR").setValue(DeptID);
 		InitRESClinicGroup(tmp[1]);
 		var SelText=$HUI.combobox("#RESCTLOCDR").getText();
 		if(SelText.indexOf("-")>-1){SelText=SelText.split("-")[0]}
		$HUI.combobox("#RESCTLOCDR").setText(SelText);
  	}
  	if(PageLogicObj.isLocChange){
	  	var MarkID=CheckComboxSelData("MarkCode",tmp[1]);
		$HUI.combobox("#MarkCode").setValue(MarkID);
		var SelText=$HUI.combobox("#MarkCode").getText();
		if(SelText.indexOf("-")>-1){SelText=SelText.split("-")[0]}
		$HUI.combobox("#MarkCode").setText(SelText);
  	}	
  	//web.DHCRBResource.GetResourceById
  	$.cm({
  		ClassName:"web.DHCRBResource",
		MethodName:"GetResourceById",
		DocId:tmp[0],
		js:"",
		dataType:"text"
  	},function(getData){
		ClearData();
		var DataArr=getData.split("^");
		
		var clinicGroupDR = DataArr[0];
 	  	var sessionType = DataArr[1];
 	  	var RESLoad= DataArr[2];
 	  	var RESAppLoad= DataArr[3];
 	  	var RESAppStartNum= DataArr[4];
 	  	var RESAddLoad= DataArr[5];
 	  	var RESEPMarkFlag=DataArr[9];
 	  	var RESAllowGetSeqNoFlag=DataArr[13];
 	  	//sessionType=sessionType.Trim()
 	  	//clinicGroupDR=clinicGroupDR.Trim()
 	  	$HUI.combobox("#RESSessionType").setValue(sessionType);	
		$HUI.combobox("#RESClinicGroup").setValue(clinicGroupDR);
		RESLoad=parseInt(RESLoad)
		//RESAppLoad=parseInt(RESAppLoad)
		//RESAppStartNum=parseInt(RESAppStartNum)
		RESAddLoad=parseInt(RESAddLoad)
		$('#RESLoad').numberbox('setValue',RESLoad);
		//$('#RESAppLoad').numberbox('setValue',RESAppLoad);
		//$('#RESAppStartNum').numberbox('setValue',RESAppStartNum);
		$('#RESAddLoad').numberbox('setValue',RESAddLoad);
		if(RESEPMarkFlag=="Y"){RESEPMarkFlag=true}
		else{RESEPMarkFlag=false}
		if(RESAllowGetSeqNoFlag=="Y"){RESAllowGetSeqNoFlag=true}
		else{RESAllowGetSeqNoFlag=false}
		$HUI.checkbox("#RESEPMarkFlag").setValue(RESEPMarkFlag);
		$HUI.checkbox("#RESAllowGetSeqNoFlag").setValue(RESAllowGetSeqNoFlag);	
	})
	PutTimeRangeselectHandle();
}

function ListDoctorChangeHandle(){
	var tmp=$("#List_Doctor option:selected").val().split(String.fromCharCode(2));
  	if(PageLogicObj.isDocChange){
	  	var DeptID=CheckComboxSelData("RESCTLOCDR",tmp[1]);
 		$HUI.combobox("#RESCTLOCDR").setValue(DeptID);
 		InitRESClinicGroup(tmp[1]);
  	}
  	if(PageLogicObj.isLocChange){
	  	var MarkID=CheckComboxSelData("MarkCode",tmp[1]);
		$HUI.combobox("#MarkCode").setValue(MarkID);
  	}	
  	$.cm({
  		ClassName:"web.DHCRBResource",
		MethodName:"GetResourceById",
		DocId:tmp[0],
		js:"",
		dataType:"text"
  	},function(getData){
		ClearData();
		var DataArr=getData.split("^");
		
		var clinicGroupDR = DataArr[0];
 	  	var sessionType = DataArr[1];
 	  	var RESLoad= DataArr[2];
 	  	var RESAppLoad= DataArr[3];
 	  	var RESAppStartNum= DataArr[4];
 	  	var RESAddLoad= DataArr[5];
 	  	var RESEPMarkFlag=DataArr[9];
 	  	var RESAllowGetSeqNoFlag=DataArr[13];
 	  	RESLoad=parseInt(RESLoad)
		//RESAppLoad=parseInt(RESAppLoad)
		//RESAppStartNum=parseInt(RESAppStartNum)
		RESAddLoad=parseInt(RESAddLoad)
 	  	//sessionType=sessionType.Trim()
 	  	//clinicGroupDR=clinicGroupDR.Trim()
 	  	$HUI.combobox("#RESSessionType").setValue(sessionType);	
		$HUI.combobox("#RESClinicGroup").setValue(clinicGroupDR);
		$('#RESLoad').numberbox('setValue',RESLoad);
		//$('#RESAppLoad').numberbox('setValue',RESAppLoad);
		//$('#RESAppStartNum').numberbox('setValue',RESAppStartNum);
		$('#RESAddLoad').numberbox('setValue',RESAddLoad);
		if(RESEPMarkFlag=="Y"){RESEPMarkFlag=true}
		else{RESEPMarkFlag=false}
		if(RESAllowGetSeqNoFlag=="Y"){RESAllowGetSeqNoFlag=true}
		else{RESAllowGetSeqNoFlag=false}
		$HUI.checkbox("#RESEPMarkFlag").setValue(RESEPMarkFlag);
		$HUI.checkbox("#RESAllowGetSeqNoFlag").setValue(RESAllowGetSeqNoFlag);	
	})
	PutTimeRangeselectHandle();
}

function PutTimeRangeselectHandle(){
	var TimeRange=$HUI.combobox("#TimeRange").getValue();	
	if(TimeRange=="")return;	
	//var tmp=$("#List_Doctor option:selected").val().split(String.fromCharCode(2));
	var RowID="";
	var row=PageLogicObj.m_DoctorDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择科室或医生","info");
		return false;
	}
	tmp=row.RowID.split("@");
	var RowID=tmp[0];
	$.cm({
  		ClassName:"web.DHCRBResource",
		MethodName:"GetTimeRangeResourceById",
		DocId:tmp[0],
		TimeRangeDR:TimeRange,
		dataType:"text"
  	},function(getData){
		ClearDataNew();
		var DataArr=getData.split("^");
 	  	var ResLoadNew= DataArr[2];
 	  	//var ResAppLoadNew= DataArr[3];
 	  	//var ResAppStartNew= DataArr[4];
 	  	ResLoadNew=parseInt(ResLoadNew)
		//ResAppStartNew=parseInt(ResAppStartNew)
		//ResAppLoadNew=parseInt(ResAppLoadNew)
		$('#ResLoadNew').numberbox('setValue',ResLoadNew);
		//$('#ResAppLoadNew').numberbox('setValue',ResAppLoadNew);
		//$('#ResAppStartNew').numberbox('setValue',ResAppStartNew);
	})
}

function ClearData(){
	$HUI.combobox("#RESSessionType").setValue("");	
	$HUI.combobox("#RESClinicGroup").setValue("");
	$('#RESLoad').numberbox('setValue',"");
	//$('#RESAppLoad').numberbox('setValue',"");
	//$('#RESAppStartNum').numberbox('setValue',"");
	$('#RESAddLoad').numberbox('setValue',"");
	$HUI.checkbox("#RESEPMarkFlag").setValue(false);
	$HUI.checkbox("#RESEPMarkFlag",{checked:false});
	$HUI.checkbox("#RESAllowGetSeqNoFlag").setValue(false);
	$HUI.checkbox("#RESAllowGetSeqNoFlag",{checked:false});
}

function ClearDataNew(){
	$('#ResLoadNew').numberbox('setValue',"");
	//$('#ResAppLoadNew').numberbox('setValue',"");
	//$('#ResAppStartNew').numberbox('setValue',"");
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
   //浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        //e.preventDefault(); 
        return false;  
    }  
}