var PageLogicObj = {
	version:"V8.4",
	ClassName:"DHCDoc.Interface.Outside.Config",
    GroupRowId:"",
    MinorCTLocListDataGrid:"",
    EmpowerLocListDataGrid:"",
    EmpowerResListDataGrid:""
}
var arrayObj1=new Array(
	new Array("Check_UsePAPMINoToCard","UsePAPMINoToCard"),
	new Array("Check_HisCreateCardNo","HisCreateCardNo"),
	new Array("Check_NotUseLockReg","NotUseLockReg"),
	new Array("Check_LockNotAllowAdd","LockNotAllowAdd"),
	new Array("Check_InsuPatSelfPayReg","InsuPatSelfPayReg"),
	new Array("Check_AppReg","AppReg"),
	new Array("OutRegStartTime","OutRegStartTime"),
	new Array("OutRegEndTime","OutRegEndTime"),
	new Array("Check_AllowRelateCard","AllowRelateCard"),
	new Array("Check_LockUseTimeRange","LockUseTimeRange"),
	new Array("Check_InsuReg","InsuReg"),
	new Array("Check_AllowAddReg","AllowAddReg"),
	new Array("Check_UseDataCompare","UseDataCompare"),
	new Array("Check_QuitNoAvailbleSchdule","QuitNoAvailbleSchdule")
)

var arrayObj2=new Array(
	new Array("List_SelfAdmReason","SelfAdmReason"),
	new Array("List_AppRegMethod","AppRegMethod"),
	new Array("List_GetPatientIDRule","GetPatientIDRule"),
	new Array("List_BarCardType","BarCardType"),
	new Array("List_AppRegMajorCTLocSort","AppRegMajorCTLocSort"),
	new Array("List_DataCompareExtOrg","DataCompareExtOrg")
);

var arrayObj3=new Array(
  	new Array("Text_LockActiveTime","LockActiveTime"),
  	new Array("Text_LockCacheTime","LockCacheTime")
);

var arrayObj4=new Array(
	new Array("List_CardType","CardType"),
	new Array("List_IDCardType","IDCardType"),
	new Array("List_ExtUserID","ExtUserID"),
	new Array("List_AdmReason","AdmReason")
);

$(document).ready(function(){
	//Init();
	InitHospList();
	InitEvent();
})

function InitHospList()
{
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_Interface_OutsideConfig",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){		
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}

function Init(){
	//InitGroupList();	
	InitGroupListGrid();	
	PageLogicObj.MinorCTLocListDataGrid=InitMinorCTLoc();
	InitOPRapidRegLoc();
	InitOPRapidRegRes();
}

function InitEvent(){
	//�����¼�
	$("#BSave").click(SaveClick);
	//�����¼�
	$("#BSaveDefault").click(SaveDefaultClick);
	$("#BReadMe").click(function(){
		var url="dhcdoc.interface.outside.configexp.hui.csp";
		if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
		var OpenWindow=window.open(url,"��������","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width="+800+",height="+600+",top="+100+"");         
		OpenWindow.focus(); 
	});	
	
	$("#BMinorCTLoc").click(function(){
		if(PageLogicObj.GroupRowId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ���õİ�ȫ��","warning");
			return false;
		}
		MinorCTLocLoad(PageLogicObj.GroupRowId);
		$("#MinorCTLoc-dialog").dialog("open");
	});	
	
	$("#BOPRapidReg").click(function(){
		if(PageLogicObj.GroupRowId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ���õİ�ȫ��","warning");
			return false;
		}
		$("#FindLoc").searchbox("setValue","");
		FindLocChange();
		FindResChange();
		$("#OPRapidReg-dialog").dialog("open");
	});	
	$("#BSaveEmpower").click(function(){
		SaveEmpowerHandle();
	})
	document.onkeydown = Doc_OnKeyDown;
}
function LoadGroupListGridData(){
	$("#GroupListGrid").datagrid("reload");	
}
function InitGroupListGrid(){
	PageLogicObj.GroupRowId="";
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	var GridSetColumns=[[  
		{ field: 'RowId', title: 'ID', width: 10,hidden:true
		}, 
		{ field: 'Code', title: '��ȫ������', width: 200,sortable:true
		}
	]];
	var CurePartGrpSetDataGrid=$("#GroupListGrid").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : true,
		url : $URL+"?ClassName="+PageLogicObj.ClassName+"&QueryName=FindList&ListName=SSGroup&HospitalId="+HospRowId+"&rows=99999",
		loadMsg : '������..',  
		pagination : true, 
		rownumbers : true,
		idField:"RowId",
		pageSize: 10,
		pageList : [10,20,50],
		columns :GridSetColumns,
		onBeforeLoad:function(param){
			$(this).datagrid("clearSelections");
			var UserHospID=$HUI.combogrid('#_HospList').getValue();
			var SDesc=$("#GDesc").searchbox("getValue");
			var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID'];
			$.extend(param,{desc:SDesc,HospitalId:UserHospID});
		},
		onLoadSuccess:function(data){
			PageLogicObj.GroupRowId="";
			ClearAllData();
			InitDefaultData();
			for(var i=0;i<arrayObj2.length;i++) {
				var param1=arrayObj2[i][0];
				var param2=arrayObj2[i][1];
				InitList(param1,param2);	    
			}
		},
		onSelect:function(rowIndex, rowData){ 
			PageLogicObj.GroupRowId=rowData.RowId;
			InitData();
		},
		onBeforeSelect:function(rowIndex, rowData){ 
			PageLogicObj.GroupRowId="";
		}
	});
	return CurePartGrpSetDataGrid;	
}
function InitGroupList(){
	PageLogicObj.GroupRowId="";
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	$HUI.combobox('#List_SSGroup',{      
    	valueField:'RowId',   
    	textField:'Code',
    	//editable:false,
    	page:1,  
		rows:9999,
    	url:$URL+"?ClassName="+PageLogicObj.ClassName+"&QueryName=FindList&ListName=SSGroup&HospitalId="+HospRowId+"&ResultSetType=array",
    	onLoadSuccess:function(){
			var sbox = $HUI.combobox("#List_SSGroup");
			sbox.clear();
			ClearAllData();
			InitDefaultData();
		},onSelect:function(){
			PageLogicObj.GroupRowId="";
			var boxvalue=$('#List_SSGroup').combobox('getValue');
			if((boxvalue!="undefined")&&(boxvalue!="")){
				PageLogicObj.GroupRowId = $('#List_SSGroup').combobox('getValue'); 
			}else{
				$.messager.alert("��ʾ","��ȫ��ID������ȡ����");
				return false;	
			} 
			InitData();
		}
	});	
}

function ClearAllData(){
	for( var i=0;i<arrayObj2.length;i++) {
		var param1=arrayObj2[i][0];
		var param2=arrayObj2[i][1];
		SetElementData(param1,"");	    
	}
	//���е�checkbox radioԪ�س�ʼ�� 
	for( var i=0;i<arrayObj1.length;i++) {
		var param1=arrayObj1[i][0];
		var param2=arrayObj1[i][1];
		SetElementData(param1,false);	    
	}
	//����textԪ�س�ʼ��
	for( var i=0;i<arrayObj3.length;i++) {
		var param1=arrayObj3[i][0];
		var param2=arrayObj3[i][1];
		SetElementData(param1,"");	    
	}		
}

function SetElementData(name,value){
	var className=$("#"+name).attr("class")
	if(typeof className =="undefined"){
		return;
	}
	if(className.indexOf("hisui-combobox")>=0){
		if(!value){value=""}
		$HUI.combobox("#"+name).setValue(value);  
    }else if(className.indexOf("hisui-timespinner")>=0){
	    if(!value){value=""}
        $HUI.timespinner("#"+name).setValue(value);  
    }else if(className.indexOf("hisui-checkbox")>=0){
        if((value=="0")||(value=="N")){
			value=false;
		}
		if((value=="1")||(value=="Y")){
			value=true;
		}
		$HUI.checkbox("#"+name).setValue(value);
    }else if(className.indexOf("hisui-numberbox")>=0){
        if(!value){value=""}
        $HUI.numberbox("#"+name).setValue(value);  
    }else{
	    if(!value){value=""}
        $("#" + name).val(value);
    }	
}

function InitDefaultData(){
	for( var i=0;i<arrayObj4.length;i++) {
		var param1=arrayObj4[i][0];
		var param2=arrayObj4[i][1];
		InitList1(param1,param2);	    
	}
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	var ObjRet=$.cm({
		ClassName:PageLogicObj.ClassName,
		MethodName:"getDefaultData",
		Node1:PageLogicObj.GroupRowId,
		Node2:"LockActiveTime",
		HospId:HospRowId
	},false)
	$("#Text_LockActiveTime").numberbox('setValue',ObjRet.result);	
}

function InitList1(param1,param2)
{
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	$HUI.combobox("#"+param1+"",{      
    	valueField:'RowId',   
    	textField:'Code',
    	//editable:false,
    	rows:999,
    	url:$URL+"?ClassName="+PageLogicObj.ClassName+"&QueryName=FindList&ListName="+param2+"&GroupRowId="+""+"&HospitalId="+HospRowId+"&ResultSetType=array",
    	onLoadSuccess:function(){
	    	SetCombDefValue(param1);
		}
	});
}

//���ݰ�ȫ���ʼ��������ֵ
function InitData(){
	if(PageLogicObj.GroupRowId==""){
		$.messager.alert("��ʾ","��ȫ��ID������ȡ����");
		return false;
	}
	for( var i=0;i<arrayObj2.length;i++) {
		var param1=arrayObj2[i][0];
		var param2=arrayObj2[i][1];
		//InitList(param1,param2);
		if (param1=="List_AppRegMajorCTLocSort") {
			$.cm({
				ClassName:PageLogicObj.ClassName,
				MethodName:"GetConfigNode",
				NodeValue:PageLogicObj.GroupRowId,
				NodeName:"AppRegMajorCTLocSort",
				HospId:$HUI.combogrid('#_HospList').getValue(),
				dataType:"text"
			},function(rtn) {
				if ($.hisui.indexOfArray($("#List_AppRegMajorCTLocSort").combobox('getData'),"SortType",rtn) >=0) {
					$("#List_AppRegMajorCTLocSort").combobox("setText",rtn);
				}else{
					$("#List_AppRegMajorCTLocSort").combobox("setText","");
				}
			})
		}else{
			$HUI.combobox("#"+param1+"").reload();	 
		}   
	}
	//���е�checkbox radioԪ�س�ʼ�� 
	for( var i=0;i<arrayObj1.length;i++) {
		var param1=arrayObj1[i][0];
		var param2=arrayObj1[i][1];
		LoadCheckData(param1,param2);	    
	}
	//����textԪ�س�ʼ��
	for( var i=0;i<arrayObj3.length;i++) {
		var param1=arrayObj3[i][0];
		var param2=arrayObj3[i][1];
		LoadTextData(param1,param2);	    
	}	
}

function LoadTextData(param1,param2)
{
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	if(PageLogicObj.GroupRowId!=""){
		var ObjRet=$.cm({
			ClassName:PageLogicObj.ClassName,
			MethodName:"getDefaultData",
			Node1:PageLogicObj.GroupRowId,
			Node2:param2,
			HospId:HospRowId
		},false)
		if(ObjRet!=""){
			$("#"+param1+"").val(ObjRet.result);	
		}
	}
}
var SortTypeData=""
function InitList(param1,param2)
{
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	if (param1=="List_AppRegMajorCTLocSort"){
			$.q({
				ClassName:"web.DHCCTLocMajor",
				QueryName:"GetDataForCmb1",
				rowid:"",desc:"",
				tableName:"User.DHCCTLocMajor",hospid:HospRowId,
				dataType:"json"
			},function(Data){
				SortTypeData=Data.rows;
				$("#List_AppRegMajorCTLocSort").combobox({
					textField:"SortType",
					valueField:"ID",
					data:Data.rows,
					OnChange:function(newValue,OldValue){
						if (!newValue) {
							$(this).combobox('setValue',"");
						}
					}
				})
			})
			if(PageLogicObj.GroupRowId!=""){
				$.cm({
					ClassName:PageLogicObj.ClassName,
					MethodName:"GetConfigNode",
					NodeValue:PageLogicObj.GroupRowId,
					NodeName:"AppRegMajorCTLocSort",
					HospId:HospRowId,
					dataType:"text"
				},function(rtn) {
					if ($.hisui.indexOfArray($("#List_AppRegMajorCTLocSort").combobox('getData'),"SortType",rtn) >=0) {
						$("#List_AppRegMajorCTLocSort").combobox("setText",rtn);
					}else{
						$("#List_AppRegMajorCTLocSort").combobox("setText","");
					}
				})	
			}else{

			}
	}else{
		var combobj={
			valueField:'RowId',   
	    	textField:'Code',
	    	editable:false,
	    	rows:9999,
	    	url:$URL+"?ClassName="+PageLogicObj.ClassName+"&QueryName=FindList&ListName="+param2+"&ResultSetType=array",
	    	onBeforeLoad:function(param){
				param = $.extend(param,{GroupRowId:PageLogicObj.GroupRowId,HospitalId:HospRowId});
			},
	    	onLoadSuccess:function(){
		    	SetCombDefValue(param1);
			}
		}
		if(param1=="List_DataCompareExtOrg"){
			$.extend(combobj,{editable:true})
		}
		$HUI.combobox("#"+param1,combobj);
	}
}

function LoadCheckData(param1,param2)
{
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	if(PageLogicObj.GroupRowId!=""){
		var objScope=$.cm({
			ClassName:PageLogicObj.ClassName,
			MethodName:"getDefaultData",
			Node1:PageLogicObj.GroupRowId,
			Node2:param2,
			HospId:HospRowId
		},false)
		if(objScope!=""){
			$("#"+param1+"").val(objScope.result);
			if((param1=="OutRegStartTime")||(param1=="OutRegEndTime")){
				$("#"+param1+"").val(objScope.result);	
			}else{
				if(objScope.result==1){
					$HUI.checkbox("#"+param1).setValue(true);
				}else{
					$HUI.checkbox("#"+param1).setValue(false);
				}
			}	
		}
	}
}

function SaveClick()
{
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	var DataList="";
	if(PageLogicObj.GroupRowId==""){
		$.messager.confirm("ȷ�϶Ի���", "δѡ��ȫ�飬�Ƿ����ֻ���汾Ժ��ȫ�����ã�", function (r) {
			if (r) {
				for( var i=0;i<arrayObj2.length;i++) {
				   var param1=arrayObj2[i][0];
				   if ((param1!="List_SelfAdmReason")&&(param1!="List_BarCardType")) {
					   continue;
				   }
				   var param2=arrayObj2[i][1];
			       var value=$("#"+param1+"").combobox("getValue")
			       if (!CheckComboValue(param1,"RowId")) return false;
				   if(DataList=="") DataList=param2+String.fromCharCode(1)+value
				   else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+value
		   		}
		   		for( var i=0;i<arrayObj3.length;i++) {
					   var param1=arrayObj3[i][0];
					   if (param1!="Text_LockActiveTime") {
						   continue;
					  }
					  var param2=arrayObj3[i][1];
				      var value=$("#"+param1+"").val();
					  if(DataList=="") DataList=param2+String.fromCharCode(1)+value
					  else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+value
			   	}
			   	var rtn=$.cm({
					ClassName:PageLogicObj.ClassName,
					MethodName:"SaveConfig",
					Coninfo:DataList,
					HospId:HospRowId,
					Node1:"",
					dataType:"text"
				},false)
				if(rtn=="0"){
					 $.messager.show({title:"��ʾ",msg:"����ɹ�"});	
					 return false;
				}
			}
		});
		//$.messager.alert("��ʾ","��ѡ��ȫ��");
		return false;
	}
	//���е�check radio�ı���
	for( var i=0;i<arrayObj1.length;i++) {
		   var param1=arrayObj1[i][0];
		   var param2=arrayObj1[i][1];
	       var CheckedValue=0;
	       
		   if((param1=="OutRegStartTime")||(param1=="OutRegEndTime")){
			    var CheckedValue= $("#"+param1+"").val();
			    var time=/^([0-1][0-9]|[2][0-3]):([0-5][0-9])$/ 
			    if ((CheckedValue!="")&&(time.test(CheckedValue) != true)) {
		          $.messager.alert("��ʾ", "ʱ���ʽ����ȷ", "error");
				  return false;
				}
		   }else{
			    var cbox=$HUI.checkbox("#"+param1+"");
				if ((cbox)&&(cbox.getValue())) {
	         		CheckedValue=1;
           		}   
		  }
          if(DataList=="") DataList=param2+String.fromCharCode(1)+CheckedValue;
		  else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+CheckedValue;		  
   	}
	
	for( var i=0;i<arrayObj2.length;i++) {
		   var param1=arrayObj2[i][0];
		   var param2=arrayObj2[i][1];
	       var value=$("#"+param1+"").combobox("getValue")
	       if (param1=="List_AppRegMajorCTLocSort") {
		       if (!CheckComboValue(param1,"SortType")) return false; //ID
		        var value=$("#"+param1+"").combobox("getText")
		   }else{
	       		if (!CheckComboValue(param1,"RowId")) return false;
	       }
		   if(DataList=="") DataList=param2+String.fromCharCode(1)+value
		   else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+value
		   
   	}
   	for( var i=0;i<arrayObj3.length;i++) {
		   var param1=arrayObj3[i][0];
		   var param2=arrayObj3[i][1];
	       var value=$("#"+param1+"").val();
		   if(DataList=="") DataList=param2+String.fromCharCode(1)+value
		   else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+value
		   
   	}
   	var rtn=$.cm({
		ClassName:PageLogicObj.ClassName,
		MethodName:"SaveConfig",
		Coninfo:DataList,
		HospId:HospRowId,
		Node1:PageLogicObj.GroupRowId,
		dataType:"text"
	},false)
	if(rtn=="0"){
		 $.messager.show({title:"��ʾ",msg:"����ɹ�"});	
		 return false;
	}
}


function SaveDefaultClick(){
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	var DataList="";
	for( var i=0;i<arrayObj4.length;i++) {
		   var param1=arrayObj4[i][0];
		   var param2=arrayObj4[i][1];
	       var value=$("#"+param1+"").combobox("getValue");
	       if (!CheckComboValue(param1,"RowId")) return false;
		   if(DataList=="") DataList=param2+String.fromCharCode(1)+value
		   else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+value
		   
   	}
   	//alert(DataList)
   	var rtn=$.cm({
		ClassName:PageLogicObj.ClassName,
		MethodName:"SetDefaultData",
		Coninfo:DataList,
		HospId:HospRowId,
		dataType:"text"
	},false)
	if(rtn=="0"){
		 $.messager.show({title:"��ʾ",msg:"����ɹ�"});	
		 return false;
	}
}

function Doc_OnKeyDown(e){
	//��ֹ�ڿհ״����˸���������Զ����˵���һ������
	if (!websys_cancelBackspace(e)) return false;
	//�������Backspace������  
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
        e.preventDefault();   
    }  
    if (e){
        var ctrlKeyFlag=e.ctrlKey;
    }else{
        var ctrlKeyFlag=window.event.ctrlKey;
    }
    if (ctrlKeyFlag){
        if (event.keyCode == 83){ //����ҽ��
            UpdateClickHandler();
        }
        return false;
	}
}

function CheckComboValue(id,CombValue)
{
	var NodeName=$("#"+id).prev().text();
	var Text=$("#"+id).combobox('getText');
	if (Text=="") {return true;}
	var Value=$("#"+id).combobox('getValue');
	if (id=="List_AppRegMajorCTLocSort") {
		Value=Text;
	}
	if(Value=="") {
		$.messager.alert('��ʾ',NodeName+' ����Ϊ��,������ѡ��');
		return false;
	}
	var DataArr=$("#"+id).combobox('getData');
	var i=0;
	for(i=0;i<DataArr.length;i++){
		var cmd="var val=DataArr[i]."+CombValue;
		eval(cmd);
		if(val==Value) break;
	}
	if(i<DataArr.length) return true;
	$.messager.alert('��ʾ',NodeName+' ֵ��Ч,������ѡ��!',"info",function(){
		$('#'+id).next('span').find('input').focus();
	});
	return false;
}

function InitMinorCTLoc()
{
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	var PrescriptTypeToolBar = [{ 
		text: '����',
		iconCls: 'icon-save',
		handler: function() {
			if(PageLogicObj.GroupRowId==""){
				$.messager.alert("��ʾ","��ȫ��ID������ȡ����");
				return false;
			}
			var Rows=PageLogicObj.MinorCTLocListDataGrid.datagrid('getRows');
			var ListData = PageLogicObj.MinorCTLocListDataGrid.datagrid('getData');
			var DataList=""
			for (var i=0;i<Rows.length;i++){
				var rows=PageLogicObj.MinorCTLocListDataGrid.datagrid("selectRow",i).datagrid("getSelected");
				var editors = PageLogicObj.MinorCTLocListDataGrid.datagrid('getEditors', i);
				var MinorCTLocSort = editors[0].target.combobox('getValue');
				if(DataList=="") DataList="MinorCTLocSort"+ListData.rows[i].RowID+String.fromCharCode(1)+MinorCTLocSort
	  			else  DataList=DataList+String.fromCharCode(2)+"MinorCTLocSort"+ListData.rows[i].RowID+String.fromCharCode(1)+MinorCTLocSort
			}
			var HospRowId=$HUI.combogrid('#_HospList').getValue();
			var rtn=$.cm({
				ClassName:PageLogicObj.ClassName,
				MethodName:"SaveConfig",
				Coninfo:DataList,
				Node1:PageLogicObj.GroupRowId,
				HospId:HospRowId,
				dataType:"text"
			},false)
			if(rtn=="0"){
				 $.messager.popover({timeout:2000,msg:"����ɹ�",type:"success"});		
				 $("#MinorCTLoc-dialog").dialog("close");
			}
		}
	}];
	var PrescriptTypeColumns=[[    
	    { field: 'RowID', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
		}, 
		{ field: 'Code', title: 'һ������', width: 20, align: 'center', sortable: true
		},
		{ field: 'MinorCTLocSort', title: '���������Ŷӷ���', width: 20, align: 'center', sortable: true,resizable: true,
		   editor :{  
				type:'combobox',  
				options:{
						url:"",
						valueField:'SortType',
						textField:'SortType',
						required:false,
						loadFilter: function(data){
							return data['rows'];
						}
				  }
			  },
			  formatter:function(value, record){
				  return record.SortType;
			  }
		}
		
	 ]];
	var PrescriptSetDataGrid=$('#MinorCTLocList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true,
		idField:"RowID",
		pageSize:15,
		pageList : [15,50,100],
		columns :PrescriptTypeColumns,
		toolbar:PrescriptTypeToolBar,
		onClickRow:function(rowIndex, rowData){
		},
		onDblClickRow:function(rowIndex, rowData){ 
       },
       onLoadSuccess:function(data){
	        var Rows=PageLogicObj.MinorCTLocListDataGrid.datagrid('getRows');
			var ListData = PageLogicObj.MinorCTLocListDataGrid.datagrid('getData');
			for (var i=Rows.length-1;i>=0;i--) {
				PageLogicObj.MinorCTLocListDataGrid.datagrid("beginEdit", i);
				var ed=PageLogicObj.MinorCTLocListDataGrid.datagrid('getEditor',{index:i,field:'MinorCTLocSort'});
				var unitUrl=$URL+"?ClassName=web.DHCCTLocMajor&QueryName=GetDataForCmb1Sub&tableName=User.DHCCTLocMinor&hospid="+HospRowId+"&MasterRowID="+ ListData.rows[i].RowID;
				$(ed.target).combobox('reload',unitUrl);
				$(ed.target).combobox('setValue', ListData.rows[i].MinorCTLocSort);
			}
	   },
	   onBeforeLoad:function(param){
	
	   }
	});
	return PrescriptSetDataGrid
}
function MinorCTLocLoad(GroupID){
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	$.q({
	    ClassName : PageLogicObj.ClassName,
	    QueryName : "GetMajorLocList",
	    GroupID : GroupID,
	    HospId :HospRowId,
	    Pagerows:PageLogicObj.MinorCTLocListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.MinorCTLocListDataGrid.datagrid("unselectAll");
		PageLogicObj.MinorCTLocListDataGrid.datagrid('loadData',GridData);
	}); 
}

function InitDataCompareExtOrg(){
	$HUI.combobox("#List_DataCompareExtOrg", {
		url:$URL+"?ClassName=web.DHCDocExtData&QueryName=ExtOrgDataQuery&Active=Y&ResultSetType=array",
		valueField:'ExtOrgRowid',
		textField:'TExtOrgDesc',
		//editable:false,
		onSelect: function () {
		}
	});
}

function SetCombDefValue(param){
	var sbox = $HUI.combobox("#"+param);
	sbox.setValue("");
	var Data=sbox.getData();
	for (var i=0;i<Data.length;i++){
		if(Data[i].selected==1){
			sbox.setValue(Data[i].RowId);
			break;	
		}
	}	
}

function FindLocChange(){
	PageLogicObj.EmpowerLocListDataGrid.datagrid("reload");
}
function FindResChange(){
	PageLogicObj.EmpowerResListDataGrid.datagrid("reload");
}

function InitOPRapidRegLoc(){
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	PageLogicObj.EmpowerLocListDataGrid=$("#LocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : true,
		url : $URL+"?ClassName="+PageLogicObj.ClassName+"&QueryName=FindList&ListName=EmpowerLoc&HospitalId="+HospRowId+"&rows=99999",
		loadMsg : '������..',  
		pagination : true, 
		rownumbers : true,
		idField:"RowId",
		pageSize: 10,
		pageList : [10,20,50],
		columns :[[  
			{ field: 'RowId', title: 'ID', width: 10,hidden:true
			}, 
			{ field: 'Code', title: '��������', width: 260,sortable:true
			}
		]],
		onBeforeLoad:function(param){
			var UserHospID=$HUI.combogrid('#_HospList').getValue();
			var SDesc=$("#FindLoc").searchbox("getValue");
			$.extend(param,{desc:SDesc,HospitalId:UserHospID});
		},
		onLoadSuccess:function(data){
			$(this).datagrid("clearSelections");
			FindResChange();
		},
		onSelect:function(rowIndex, rowData){ 
			FindResChange();
		}
	});
}
function InitOPRapidRegRes(){
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	PageLogicObj.EmpowerResListDataGrid=$("#ResListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : true,
		url : $URL+"?ClassName="+PageLogicObj.ClassName+"&QueryName=FindList&ListName=EmpowerRes&HospitalId="+HospRowId+"&rows=99999",
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : true,
		idField:"RowId",
		columns :[[
			{field:'RowId',title:'',checkbox:true},
			{field:'Code', title: 'ҽ���ű�', width: 200,sortable:true}
		]],
		onBeforeLoad:function(param){
			var row=PageLogicObj.EmpowerLocListDataGrid.datagrid("getSelected");
			if(row){
				var LocID=row.RowId;
			}else{
				var LocID="";
			}
			var UserHospID=$HUI.combogrid('#_HospList').getValue();
			var SDesc=""; //$("#FindRes").searchbox("getValue");
			$.extend(param,{desc:SDesc,GroupRowId:PageLogicObj.GroupRowId,HospitalId:UserHospID,otherVal:LocID});
		},
		onLoadSuccess:function(Data){ 
			$(this).datagrid("clearSelections");
			var rows=Data.rows;
			for(var i=0;i<rows.length;i++){
				var rowData=rows[i];
				if(rowData.selected==1){
					$(this).datagrid("checkRow",i);
				}
			}
		}
	});
}

function SaveEmpowerHandle(){
	var GroupRowId=PageLogicObj.GroupRowId;	
	if(GroupRowId==""){
		$.messager.alert("��ʾ","��ѡ��ȫ��","warning");
		return false;
	}
	var LocID="";
	var row=PageLogicObj.EmpowerLocListDataGrid.datagrid("getSelected");
	if(row){
		var LocID=row.RowId;
	}
	if(LocID==""){
		$.messager.alert("��ʾ","��ѡ�����","warning");
		return false;
	}
	var rows=PageLogicObj.EmpowerResListDataGrid.datagrid("getSelections");
	var EmpowerResArr=[];
	if(rows.length>0){
		for(var i=0;i<rows.length;i++){
			var id=rows[i].RowId;
			EmpowerResArr.push(id)		
		}
	}
	var EmpowerResStr=EmpowerResArr.join("^");
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	var DataList="EmpowerRes"+String.fromCharCode(1)+EmpowerResStr+String.fromCharCode(1)+LocID;
	var rtn=$.cm({
		ClassName:PageLogicObj.ClassName,
		MethodName:"SaveConfig",
		Coninfo:DataList,
		HospId:HospRowId,
		Node1:GroupRowId,
		dataType:"text"
	},false)
	if(rtn=="0"){
		$.messager.popover({timeout:2000,msg:"��Ȩ�ɹ�",type:"success"});	
	}		   	
}