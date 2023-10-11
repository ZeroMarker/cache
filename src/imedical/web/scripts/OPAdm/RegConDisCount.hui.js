var PageLogicObj={
	m_DHCRegConDisCountDataGrid:"",
    m_AuthFlag:tkMakeServerCall("DHCDoc.Interface.Inside.InvokeAuth","GetSwitch")        //权力系统启用
};
$(function(){
	Init();
	InitEvent();
});
function Init(){
	//初始化医院
	var hospComp = GenHospComp("DHC_RegConDisCount");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		ClearClickHandle();
		DHCRegConDisCountDataGridLoad();
		SetDetailComboValue("DocSession","ReadSessionType");
		SetDetailComboValue("FeeCate","ReadPatTypeAdm");
		SetDetailComboValue("PatType","ReadPatType");
		InitLoc();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitPriority();
		PageLogicObj.m_DHCRegConDisCountDataGrid=InitRBCASStatusDataGrid();
		DHCRegConDisCountDataGridLoad();
		LoadDetailCombo();
	}
}

function InitEvent(){
	$('#BFind').click(FindClickHandle)
	$('#BClear').click(ClearClickHandle)
	$('#BSave').click(SaveDetailClickHandle)
	$(document.body).bind("keydown",BodykeydownHandler)
}

function FindClickHandle(){
	DHCRegConDisCountDataGridLoad();
}

function ClearClickHandle(){
	ClearData();
}

function InitPriority(){
	var Dem=String.fromCharCode(1)
	var PriorityStr="1"+Dem+"Ⅰ^2"+Dem+"Ⅱ^3"+Dem+"Ⅲ^4"+Dem+"Ⅳ"
	var PriorityStrArr=PriorityStr.split("^")
	var EditTypeArr=new Array();
	for(var i=0;i<PriorityStrArr.length;i++){
		var value=PriorityStrArr[i].split(Dem)[0];
		var desc=PriorityStrArr[i].split(Dem)[1];
		var onestr = {"value":value, "desc":desc};
		EditTypeArr.push(onestr);	
	}
	$HUI.combobox("#Priority",{
		valueField:'value',   
    	textField:'desc',
    	data: EditTypeArr,
		editable:false,
		onLoadSuccess:function(){
			var boxvalue=$HUI.combobox("#Priority").setValue("");
		}	
	})
}
function InitRBCASStatusDataGrid(){
	var toobar=[{
        id:"ConDisAdd",
        text: '新增',
        iconCls: 'icon-add',
        handler: function() { AddClickHandle("N");}
    },{
        id:"ConDisUpdate",
        text: '修改',
        iconCls: 'icon-update',
        handler: function() { AddClickHandle("U");}
    },"-",{
        id:"ConDisDetail",
        text: '详细设置',
        iconCls: 'icon-edit',
        handler: function() { DetailClickHandle();}
    }/*,{
        text: '翻译',
        iconCls: 'icon-translate-word',
        handler: function() {
         	var SelectedRow = PageLogicObj.m_DHCRegConDisCountDataGrid.datagrid('getSelected');
			if (!SelectedRow){
			$.messager.alert("提示","请选择需要翻译的行!","info");
			return false;
			}
			CreatTranLate("User.DHCRegConDisCount","RCDDesc",SelectedRow["RCDDesc"])
			        }
     }*/
	 ];
	var Columns=[[ 
		{field:'RCDRowid',hidden:true,title:''},
		{field:'RCDCode',title:'优惠代码',width:300},
		{field:'RCDDesc',title:'优惠描述',width:300},
		{field:'RCDPriority',title:'优先级',width:200},
		{field:'RCDStartDate',title:'开始日期',width:300},
		{field:'RCDStartTime',title:'开始时间',width:250},
		{field:'RCDEndDate',title:'结束日期',width:300},
		{field:'RCDEndTime',title:'结束时间',width:250},
		{field:'RCDOtherDesc',title:'其他描述',width:300},
		{field:'RCDHospitalDesc',title:'医院',width:300},
		{field:'RCDPriorityRowid',hidden:true,width:300}
    ]]
	var RBCASStatusDataGrid=$("#DHCRegConDisCountTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'RCDRowid',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			ClearData();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_DHCRegConDisCountDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_DHCRegConDisCountDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_DHCRegConDisCountDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return RBCASStatusDataGrid;
}
function SetSelRowData(row){
	$HUI.combobox("#Priority").setValue(row["RCDPriorityRowid"]);
	$("#Code").val(row["RCDCode"]);
	$("#Desc").val(row["RCDDesc"]);
	$("#OtherDesc").val(row["RCDOtherDesc"]);
	$HUI.datebox("#StartDate").setValue(row["RCDStartDate"]);
	$("#StartTime").val(row["RCDStartTime"]);
	$HUI.datebox("#EndDate").setValue(row["RCDEndDate"]);
	$("#EndTime").val(row["RCDEndTime"]);	
}
function AddClickHandle(param){
	var RCDRowid="";
	if(param=="U"){
		var row=PageLogicObj.m_DHCRegConDisCountDataGrid.datagrid('getSelected');
		if ((!row)||(row.length==0)){
			$.messager.alert("提示","请选择需要更新的行!","info");
			return false;
		}
		RCDRowid=row.RCDRowid;	
	}
	
	if (!CheckDataValid()) return false;
	var PriorityDr=$HUI.combobox("#Priority").getValue();
	var Code=$("#Code").val();
	var Desc=$("#Desc").val();
	var StartDate=$HUI.datebox("#StartDate").getValue();
	var StartTime=$("#StartTime").val();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	var EndTime=$("#EndTime").val();
	var OtherDesc=$("#OtherDesc").val();
	var HospitalDr=$HUI.combogrid('#_HospList').getValue();
	if (HospitalDr==""){
		$.messager.alert("提示","请选择医院!","info");
		return false;
	}
	$.cm({
		ClassName:"web.DHCRegConDisCount",
		MethodName:"UpdateDHCRegConDisCount",
		RCDRowid:RCDRowid,
		Priority:PriorityDr,
		RCDCode:Code,
		RCDDesc:Desc,
		RCDStartDate:StartDate,
		RCDStartTime:StartTime,
		RCDEndDate:EndDate,
		RCDEndTime:EndTime,
		RCDOtherDesc:OtherDesc,
		RCDHospitalDr:HospitalDr,
		dataType:"text"
	},function(rtn){
		if (rtn=="0"){
			$.messager.show({title:"提示",msg:"操作成功"});
			PageLogicObj.m_DHCRegConDisCountDataGrid.datagrid('uncheckAll');
			DHCRegConDisCountDataGridLoad();
			ClearData();
		}else if(rtn=="repeat"){
			$.messager.alert("提示","操作失败!优惠代码或优惠描述记录重复!","error");
			return false;
		}else{
			$.messager.alert("提示","操作失败!错误代码:"+rtn,"error");
			return false;
		}
	});
}

function DetailClickHandle(){
	var RCDRowid="";
	var row=PageLogicObj.m_DHCRegConDisCountDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要设置的优惠设置!","info");
		return false;
	}
	RCDRowid=row.RCDRowid;	
	$("#add-dialog").dialog("open");
	$('#add-form').form("clear");
	ClearDetailData();
	InitDetailData(RCDRowid);
}

function InitDetailData(Rowid){
	if(Rowid!=""){
		$.cm({
			ClassName:"web.DHCRegConDisCount",
			MethodName:"GetDHCRegConDisCountById",
			'RCDRowid':Rowid,
			dataType:"text",
		},function(value){
			if(value=="")return;
			var arr=value.split("^");
			$HUI.combobox("#Sex").setValue(arr[12]);	
			$HUI.combobox("#AgeCompare").setValue(arr[10]);
			$('#Age').numberbox('setValue',arr[9]);
			$HUI.combobox("#Dept").setValue(arr[14]);
			InitDoc(arr[14],arr[16])
			$HUI.combobox("#FeeCate").setValue(arr[18]);
			$HUI.combobox("#PatType").setValue(arr[20]);
			if(arr[22]==1){$HUI.checkbox("#OldCard").setValue(true);}
			else{$HUI.checkbox("#OldCard").setValue(false);}
			$HUI.combobox("#DocSession").setValue(arr[23]);
		})
	}
}

function ClearDetailData(){
	$HUI.combobox("#Sex").setValue("");	
	$HUI.combobox("#AgeCompare").setValue("");
	$('#Age').numberbox('setValue',"");
	$HUI.combobox("#Dept").setValue("");
	$HUI.combobox("#Mark").setValue("");
	$HUI.combobox("#FeeCate").setValue("");
	$HUI.combobox("#PatType").setValue("");
	$HUI.checkbox("#OldCard").setValue(false);
	$HUI.checkbox("#OldCard",{checked:false});
	$HUI.combobox("#DocSession").setValue("");
}

function ClearData(){
	$HUI.combobox("#Priority").setValue("");
	$("#Code").val("");
	$("#Desc").val("");
	$("#OtherDesc").val("");
	$HUI.datebox("#StartDate").setValue("");
	$("#StartTime").val("");
	$HUI.datebox("#EndDate").setValue("");
	$("#EndTime").val("");
}
function CheckDataValid(){
	var PriorityDr=$HUI.combobox("#Priority").getValue();
	if (PriorityDr==""){
		$.messager.alert("提示","请选择优惠级别","info");
		return false;
	}
	var Code=$("#Code").val();
	if (Code==""){
		$.messager.alert("提示","缺少优惠代码","info",function(){$("#Code").focus();});
		return false;
	}
	var Desc=$("#Desc").val();
	if (Desc==""){
		$.messager.alert("提示","缺少优惠描述","info",function(){$("#Desc").focus();});
		return false;
	}
	
	var StartDate=$HUI.datebox("#StartDate").getValue();
	if (StartDate==""){
		$.messager.alert("提示","缺少优惠开始日期","info",function(){$("#StartDate").focus();});
		return false;
	}
	var StartTime=$("#StartTime").val();
	if (StartTime==""){
		$.messager.alert("提示","缺少优惠开始时间","info",function(){$("#StartTime").focus();});
		return false;
	}
	var EndDate=$HUI.datebox("#EndDate").getValue();
	var EndTime=$("#EndTime").val();
	var Rtn=CompareDate(StartDate,EndDate)
	if (!Rtn){
		$.messager.alert("提示","结束日期不能小于开始日期!","info");
		return Rtn
	}
	var OtherDesc=$("#OtherDesc").val();
	
	return true;
}
function DHCRegConDisCountDataGridLoad(){
	var HospitalDr=$HUI.combogrid('#_HospList').getValue();
	var PriorityDr=$HUI.combobox("#Priority").getValue();
	var Code=$("#Code").val();
	var Desc=$("#Desc").val();
	$.q({
	    ClassName : "web.DHCRegConDisCount",
	    QueryName : "FindDHCRegConDisCount",
	    'HospitalDr':HospitalDr,
	    'Priority':PriorityDr,
	    'Code':Code,
	    'Desc':Desc,
	    Pagerows:PageLogicObj.m_DHCRegConDisCountDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_DHCRegConDisCountDataGrid.datagrid('clearSelections').datagrid('clearChecked').datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
    LoadAuthHtml();
}

function LoadDetailCombo(){
	InitLoc();
	SetDetailComboValue("Sex","ReadSex")
	SetDetailComboValue("AgeCompare","ReadCompare")
	SetDetailComboValue("FeeCate","ReadPatTypeAdm")
	SetDetailComboValue("PatType","ReadPatType")
	SetDetailComboValue("DocSession","ReadSessionType")
}

function InitLoc(){
    $.cm({
		ClassName:"web.DHCOPAdmReg",
		QueryName:"OPDeptList",
		'UserId':"",
		'AdmType':"O^I^E",
		HospitalID:$HUI.combogrid('#_HospList').getValue(),
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#Dept", {
				valueField: 'CTCode',
				textField: 'CTDesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["CTDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["CTAlias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onSelect:function(record){
					InitDoc(record.CTCode,"");
				},onChange:function(newValue,OldValue){
					if (!newValue) InitDoc("","");
				}
		 });
	});
}


function InitDoc(val,setval){
	//if((typeof(val)=='undefined')||(val==""))return;
    $.cm({
		ClassName:"web.DHCRegConDisCount",
		QueryName:"Findloc",
		'depid':val,
		'markname':"",
		HospitalID:$HUI.combogrid('#_HospList').getValue(),
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#Mark", {
				valueField: 'RowID',
				textField: 'Desc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["Desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(){
					$HUI.combobox('#Mark').setValue("");
					if((typeof(setval)!='undefined')&&(setval!="")){
						$HUI.combobox('#Mark').setValue(setval);	
					}
				}
				
		 });
	});
}

function SetDetailComboValue(ComboName,param){
	var getData=$.cm({
		ClassName:"web.DHCRegConDisCount",
		MethodName:param,
		JSFunName:"",
		ListName:"",
		RCDRowid:"",
		HospID:$HUI.combogrid('#_HospList').getValue(),
		JSON:"JSON",
		dataType:"text"	
	},false)
	var DataArr=new Array()
	if(getData!=""){
		var len=getData.split("^").length		
	for(var i=0;i<len;i++){
		var oneValue=getData.split("^")[i];
		var value=oneValue.split(String.fromCharCode(1))[0]	
		var desc=oneValue.split(String.fromCharCode(1))[1];
		var oneValue = {"value":value, "desc":desc};
		DataArr.push(oneValue);
		}
	}
	$HUI.combobox('#'+ComboName,{      
    	valueField:'value',   
    	textField:'desc',
    	data: DataArr,
		//editable:false,
    	onLoadSuccess:function(){
			$HUI.combobox('#'+ComboName).setValue("");
		}
	});		
}

function SaveDetailClickHandle(){
	var RCDRowid="";
	var row=PageLogicObj.m_DHCRegConDisCountDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要设置的优惠设置!","info");
		return false;
	}
	RCDRowid=row.RCDRowid;	
	var SexDr=getValue('Sex'); 
	var AgeCompare=getValue('AgeCompare'); 
	var Age=$('#Age').numberbox('getValue');
	var DeptID=getValue('Dept');
	var MarkID=getValue('Mark'); 
	var FeeCateDr=getValue('FeeCate');
	var PatTypeDr=getValue('PatType'); 
	var OldCard=$HUI.checkbox("#OldCard").getValue();
	var DocSessionDr=getValue('DocSession'); 
	if(OldCard){
		OldCard=1;	
	}else{
		OldCard=0;	
	}
    var ClassName="web.DHCRegConDisCount";
    var MethodName="UpdateDHCRegConDisCountSet";
    if (PageLogicObj.m_AuthFlag==1){
        ClassName="DHCDoc.Interface.Inside.InvokeAuth";
        MethodName="InvokeRegConDisCountSetAuth";
    }
	$.cm({
		ClassName:ClassName,
		MethodName:MethodName,
		RCDRowid:RCDRowid,
		Age:Age,
		AgeCompare:AgeCompare,
		SexDr:SexDr,
		DeptDr:DeptID,
		MarkDr:MarkID,
		FeeCateDr:FeeCateDr,
		PatTypeDr:PatTypeDr,
		OldCard:OldCard,
		DocSessionDr:DocSessionDr,
		dataType:"text"		
	},function(ret){
        if (PageLogicObj.m_AuthFlag==1){
            var Arr=ret.split("^");
            $.messager.alert("提示",Arr[1]);
            $("#add-dialog").dialog("close");
            DHCRegConDisCountDataGridLoad();
        }else{
            if(ret==0) {
                $("#add-dialog").dialog("close");
                DHCRegConDisCountDataGridLoad();
            }else{
                $.messager.alert("提示","保存失败,错误信息:"+ret,"error");
                return false;
            }
        }
	})
}

function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="Dept"){
			var CombValue=Data[i].CTCode;
		 	var CombDesc=Data[i].CTDesc;
	     }else if (id=="Mark"){
		    var CombValue=Data[i].RowID  
		 	var CombDesc=Data[i].Desc
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
function getValue(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return $("#"+id).val()
	}
	if(className.indexOf("hisui-lookup")>=0){
		var txt=$("#"+id).lookup("getText")
		//如果放大镜文本框的值为空,则返回空值
		if(txt!=""){ 
			var val=$("#"+id).val()
		}else{
			var val=""
			$("#"+id+"Id").val("")
		}
		return val
	}else if(className.indexOf("hisui-combobox")>=0){
		var val=$("#"+id).combobox("getValue")
		if(typeof val =="undefined") val=""
		return val
	}else if(className.indexOf("hisui-datebox")>=0){
		return $("#"+id).datebox("getValue")
	}else{
		return $("#"+id).val()
	}
	return ""
}

function LoadAuthHtml() {
    $m({
        ClassName: "BSP.SYS.SRV.AuthItemApply",
        MethodName: "GetStatusHtml",
        AuthCode: "HIS-DOC-REGDISCOUNT"
    }, function (rtn) {
        if (rtn != "") {
            $(rtn).insertAfter('#BSave');
            $(rtn).insertAfter('#ConDisDetail');
        }
    })
    return;
}