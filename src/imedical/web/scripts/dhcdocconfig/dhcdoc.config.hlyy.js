var PageLogicObj={
	 m_HLYYCompanyTabDataGrid:"",
	 editRow:undefined
}
var arrayObj1=new Array(
	new Array("Check_DTDepNotDoYDTS","1"),
	new Array("Check_DTDepNotDoXHZY","2"),
	new Array("Check_DTDepNotDoUpLoad","3")
);
var arrayObj2=new Array(
	new Array("Check_DTAlertYDTSFlag","DTAlertYDTSFlag"),
	new Array("Check_DHCDTUploadFlag","DHCDTUploadFlag"),
	new Array("Check_DTCheckCNMed","DTCheckCNMed"),
	new Array("Check_JudgeOnUpdate","JudgeOnUpdate")
);
$(function(){
    InitHospList();
    $('#List_DTLimitDep').click(HLYYLimitDepConfig);
    //保存按钮
    $("#BSave").click(SaveHLYYConfig);
    $("#BCompanyConfig").click(BCompanyConfigOpen);
})
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_HLYY");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	 //接口类型
	 InitCompany("Combo_Company","CurrCompany");
	 //使用合理用药的科室
	 LoadDep("List_DTAdmDep","DTAdmDep");
	 //
	 LoadDep("List_DTLimitDep","");
	 //合理用药check设置
	 for( var i=0;i<arrayObj2.length;i++) {
		 var param1=arrayObj2[i][0];
		 var param2=arrayObj2[i][1];
		 InitHLYYOtherConfig(param1,param2);	    
	 }
	 var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"GetConfigNode",
		Node:"McSynCheckMode",
		HospId:$HUI.combogrid('#_HospList').getValue()
	  },false);
	  if (value==1){
		$("#Check_McNSynCheck").checkbox('check');
	  }else if(value==0){
		$("#Check_McSynCheck").checkbox('check');
	  }
}
function InitCompany(param1,param2){
	$("#"+param1).combobox('select',"");
	$("#"+param1).combobox({
    	valueField:'rowid',   
    	textField:'Desc',
    	url:$URL+"?ClassName=DHCDoc.DHCDocConfig.HLYY&QueryName=FindHLYYCompany&rows=99999",
		onLoadSuccess:function(data){
			var objScope=$.m({ 
				ClassName:"web.DHCDocConfig", 
				MethodName:"GetConfigNodeNew",
				Node:param2,
				HospId:$HUI.combogrid('#_HospList').getValue()
			},false);
			objScope=eval("(" + objScope + ")");
			if (objScope.result!="") {
				for (var i=0;i<data.length;i++){
					if (data[i].Code==objScope.result.split("^")[1]) {
						$("#"+param1).combobox('select',data[i].rowid);
					}
				}
			}
		},
		loadFilter:function(data){
			return data['rows'];
		}
	});	
}
function LoadDep(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.HLYY", 
		QueryName:"FinDTDep",
		value:param2,
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},false);
	 var vlist = ""; 
	 var selectlist="";
	 jQuery.each(objScope.rows, function(i, n) { 
		  selectlist=selectlist+"^"+n.selected
		  vlist += "<option value=" + n.CTLOCRowID + ">" + n.CTLOCDesc + "</option>"; 
	 });
	 $("#"+param1+"").append(vlist); 
	 for (var j=1;j<=selectlist.split("^").length;j++){
		  if(selectlist.split("^")[j]=="true"){
			  $("#"+param1+"").get(0).options[j-1].selected = true;
		  }
	  }
						  
};
function HLYYLimitDepConfig()
{
  var LimitDepRowID=$("#List_DTLimitDep").find("option:selected").val();
  if(LimitDepRowID==undefined) LimitDepRowID="";
    var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.HLYY", 
		MethodName:"GetConfigNode1",
		Node:"DTAdmDep",
		SubNode:LimitDepRowID,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	objScope=eval("(" + objScope + ")");
	for( var i=0;i<arrayObj1.length;i++) {
		  var param1=arrayObj1[i][0];
		  var Num=arrayObj1[i][1];
		  var value=objScope.result.split("^")[Num-1];
		  if (value==1){
			$("#"+param1+"").checkbox('check');
		 }else{
			$("#"+param1+"").checkbox('uncheck');
		 }
	 }
};
function InitHLYYOtherConfig(param1,param2)
{
	var value=$.cm({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"GetConfigNode",
		Node:param2,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if (value==1){
		$("#"+param1+"").checkbox('check');
	}else{
		$("#"+param1+"").checkbox('uncheck');
	}
}
function SaveHLYYConfig()
{
  var CompanyRowId=$("#Combo_Company").combobox("getValue"); 
  var ComDesc="",ComCode="";
  if(CompanyRowId!=""){
	  var HLYYCompanyData=$("#Combo_Company").combobox("getData"); 
	  for(var i=0;i<HLYYCompanyData.length;i++){
		  var Code=HLYYCompanyData[i].Code
		  if(CompanyRowId==HLYYCompanyData[i].rowid) {
			  ComDesc=HLYYCompanyData[i].Desc;
			  ComCode=HLYYCompanyData[i].Code;
		  	  break;
		  }
	  }
  }
  var param="CurrCompany"+String.fromCharCode(1)+ComDesc+"^"+ComCode;
  //使用合理用药的科室
  var DTDepStr="";
  var size = $("#List_DTAdmDep"+ " option").size();
  if(size>0){
	 $.each($("#List_DTAdmDep"+" option:selected"), function(i,own){
		 var svalue = $(own).val();
		 if (DTDepStr=="") DTDepStr=svalue;
		 else DTDepStr=DTDepStr+"^"+svalue;
	  })
  };
  param=param+String.fromCharCode(2)+"DTAdmDep"+String.fromCharCode(1)+DTDepStr
  //保存按科室禁用的功能
  var size = $("#List_DTLimitDep"+ " option").size();
  var Str="";
  if(size>0){
	  var LimitDep="";
	  $.each($("#List_DTLimitDep"+" option:selected"), function(i,own){
		 LimitDep = $(own).val();
	  })
	  if(LimitDep!=""){
		  var DTDepNotDoYDTS=$("#Check_DTDepNotDoYDTS").checkbox('getValue')?1:0
		  var DTDepNotDoXHZY=$("#Check_DTDepNotDoXHZY").checkbox('getValue')?1:0
		  var DTDepNotDoUpLoad=$("#Check_DTDepNotDoUpLoad").checkbox('getValue')?1:0
		  var param1=DTDepNotDoYDTS+"^"+DTDepNotDoXHZY+"^"+DTDepNotDoUpLoad;
		  var value=$.cm({ 
				ClassName:"web.DHCDocConfig", 
				MethodName:"SaveConfig1",
				Node:"DTAdmDep",
				Node1:LimitDep,
				NodeValue:param1,
				HospId:$HUI.combogrid('#_HospList').getValue()
		  },false);
	  }
    }
    //对草药进行合理用药检查
    var DTCheckCNMed=$("#Check_DTCheckCNMed").checkbox('getValue')?1:0
    DTCheckCNMed="DTCheckCNMed"+String.fromCharCode(1)+DTCheckCNMed
    //开医嘱弹出药典提示
    var DTAlertYDTSFlag=$("#Check_DTAlertYDTSFlag").checkbox('getValue')?1:0
    DTAlertYDTSFlag="DTAlertYDTSFlag"+String.fromCharCode(1)+DTAlertYDTSFlag
    //保存时审核
    var JudgeOnUpdate=$("#Check_JudgeOnUpdate").checkbox('getValue')?1:0
    JudgeOnUpdate="JudgeOnUpdate"+String.fromCharCode(1)+JudgeOnUpdate
    //保存时上传结果
    var DHCDTUploadFlag=$("#Check_DHCDTUploadFlag").checkbox('getValue')?1:0
    DHCDTUploadFlag="DHCDTUploadFlag"+String.fromCharCode(1)+DHCDTUploadFlag
  
    //美康审查设置
    var McSynCheck="";
    if ($("#Check_McSynCheck").checkbox("getValue")) {
	    McSynCheck=0;
    }
    if ($("#Check_McNSynCheck").checkbox("getValue")) {
	    McSynCheck=1;
    }
    McSynCheck="McSynCheckMode"+String.fromCharCode(1)+McSynCheck;
  
    param=param+String.fromCharCode(2)+DTCheckCNMed+String.fromCharCode(2)+DTAlertYDTSFlag+String.fromCharCode(2)+JudgeOnUpdate+String.fromCharCode(2)+DHCDTUploadFlag;
    param=param+String.fromCharCode(2)+McSynCheck;
    var value=$.cm({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"SaveConfig",
		Coninfo:param,
		HospId:$HUI.combogrid('#_HospList').getValue()
    },false);
	if(value=="0"){
	   $.messager.popover({msg: '保存成功!',type:'success'});
	}else{
	   $.messager.alert('提示',"保存失败:"+value);
	}
}
function BCompanyConfigOpen(){
	$("#HLYYCompany-dialog").dialog("open");
	if (PageLogicObj.m_HLYYCompanyTabDataGrid=="") {
		PageLogicObj.m_HLYYCompanyTabDataGrid=InitHLYYCompanyTabDataGrid();
	}else{
		PageLogicObj.m_HLYYCompanyTabDataGrid.datagrid("reload");
	}
}
function InitHLYYCompanyTabDataGrid(){
	var Columns=[[ 
		{ field: 'Code', title: '代码', width: 200,editor : {type : 'text',options : {}}},
		{ field: 'Desc', title: '接口名称', width: 200,editor : {type : 'text',options : {}}}
    ]]
    var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() { 
        	if (!isNaN(PageLogicObj.editRow)){
            	$.messager.alert("提示","请先保存")
            	return false
            }
            
            PageLogicObj.editRow=0;
            PageLogicObj.m_HLYYCompanyTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {
	                rowid:""
	            }
            });
            PageLogicObj.m_HLYYCompanyTabDataGrid.datagrid("beginEdit", 0);
	        var CodeObj=PageLogicObj.m_HLYYCompanyTabDataGrid.datagrid('getEditor', {index:0,field:'Code'});
			CodeObj.target.focus();
        }
    },{
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() {
	        var rows = PageLogicObj.m_HLYYCompanyTabDataGrid.datagrid("getSelections");
            if (rows.length > 0) {
				var rowid=rows[rows.length-1].rowid;
				if (rowid==0) {
					PageLogicObj.m_HLYYCompanyTabDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
		    		PageLogicObj.editRow = undefined;
				}else{
					var value=$.m({
						ClassName:"DHCDoc.DHCDocConfig.HLYY",
						MethodName:"DelHLYYCompanyConfig",
					   	rowid:rowid
					},false);
					PageLogicObj.m_HLYYCompanyTabDataGrid.datagrid("reload");
					$("#Combo_Company").combobox("select","").combobox("reload");
				}
            } else {
                $.messager.alert("提示", "请选择操作行", "error");
            }
	    }
    },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {
	        if (isNaN(PageLogicObj.editRow)){
            	$.messager.alert("提示","请先添加");
            	return false;
            }
            var rows = PageLogicObj.m_HLYYCompanyTabDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
			var Rowid=rows.rowid;
			var row=PageLogicObj.m_HLYYCompanyTabDataGrid.datagrid("getEditors",PageLogicObj.editRow);
			var Code=row[0].target.val();
			if (!Code) {
				$.messager.alert("提示","请输入接口代码，例如DT!");
            	return false;
			}else{
				var reg=/^[A-Z]+$/;
				if (!Code.match(reg)){
					$.messager.alert("提示","接口代码必须是英文大写，例如DT!");
            		return false;
				}
			}
			var Desc=row[1].target.val();
			if (!Desc) {
				$.messager.alert("提示","请输入接口名称!");
            	return false;
			}
			var value=$.m({
				ClassName:"DHCDoc.DHCDocConfig.HLYY",
				MethodName:"SaveHLYYCompanyConfig",
			   	Code:Code,
			   	Desc:Desc,
			   	rowid:Rowid
			},false);
			if (value=="-1"){
   				$.messager.alert("提示","保存失败：该代码已存在，请重新输入!");
			}else{
       			PageLogicObj.editRow=undefined;
       			PageLogicObj.m_HLYYCompanyTabDataGrid.datagrid("reload");
       			$("#Combo_Company").combobox("select","").combobox("reload");
       		}
	    }
    },{
		iconCls: 'icon-arrow-right-top',
		text:'取消编辑',
		handler: function(){
			if ((PageLogicObj.editRow!=="")&&(typeof PageLogicObj.editRow !="undefined")){
		    	PageLogicObj.m_HLYYCompanyTabDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
		    	PageLogicObj.editRow = undefined;
		    }
		}
	},'-',{
			id:'tip',
			iconCls: 'icon-help',
			text:'使用说明',
			handler: function(){
				$("#tip").popover('show');
			}
	}];
	HLYYCompanyTabDataGrid=$('#HLYYCompanyTab').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.HLYY&QueryName=FindHLYYCompany",
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : false,  //
		idField:"rowid",
		columns :Columns,
		toolbar :toobar,
		onLoadSuccess:function(data){
			PageLogicObj.editRow=undefined;
			PageLogicObj.m_HLYYCompanyTabDataGrid.datagrid("unselectAll");
		},
		onDblClickRow:function(index, row){
			if ((PageLogicObj.editRow!=undefined)&&(PageLogicObj.editRow!=index)){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			PageLogicObj.editRow=index;
			PageLogicObj.m_HLYYCompanyTabDataGrid.datagrid("beginEdit", index);
			var CodeObj=PageLogicObj.m_HLYYCompanyTabDataGrid.datagrid('getEditor', {index:index,field:'Code'});
			$(CodeObj).focus();
		}
	});
	InitTip();
	return HLYYCompanyTabDataGrid;	
}
function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>合理用药设置-接口类型使用说明</li>" + 
		"<li>1、接口类型维护是指HIS合理用药使用厂家维护，包括接口代码、接口名称，其中接口代码必须是英文大写且不可重复。</li>" +
		"<li>2、维护相应合理用药厂家且设置为默认厂家后：</li>" + 
		"<li>&nbsp&nbsp&nbsp&nbsp2.1 需增加HIS类:web.DHCDocHLYY_接口代码_.cls,例如web.DHCDocHLYYMK。</li>" +
		"<li>&nbsp&nbsp&nbsp&nbsp2.2 新增对应js:DHCDocHLYY_接口代码.js ,例如DHCDocHLYYMK.js，目录为../scripts/dhcdoc/。</li>" +
		"</ul>" 
		
	$("#tip").popover({
		width:700,
		trigger:'hover',
		content:_content
	});
}