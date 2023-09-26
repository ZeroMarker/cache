/**
 * 医保诊疗上传信息维护JS
 * Zhan 20160420
 * 版本：V1.0
 * easyui版本:1.3.2
 */
var cmenu;
var tleftgrid;
var oecongrid;
var selTarData="";
var seloeData=""
var selcondata="";
//var ROOTID='TEST2';	//测试用
var searchParam = {}; 
var seldictype=""; 
var QParam="";
var EditIndex=-2
$(function(){
	
	GetjsonQueryUrl();

	// 下拉列表
	init_SearchPanel();
	
	// 初始化模版的grid
	init_tleftdg();

	// 初始化医嘱对象列表
	init_trightdg();
	
	// 对照明细历史
	init_oecdg();
	
	//测试
	//grid.datagrid({ url: "http://hellobaidu.8866.org:83/dthealth/web/csp/insujsonbuilder.csp?ARGUS=test$web.INSUTarContrastCom$DhcTarQuery$asplp^1^CZZG^A^^", queryParams: {qid:1}});
	$('#KeyWords').keyup(function(){
		if(event.keyCode==13){
			Query()	;
			
		}
	});

	if($('#QClase').combobox('getValue')==""){$('#QClase').combobox('select','1')}
	if($('#ConType').combobox('getValue')==""){$('#ConType').combobox('select','A')}
	init_layout();	
	//$("#ActDate").datebox("setValue", GetToday());
	//$('#wind').window('open')
	//QueryOEORD();

});
/*
 * 下拉列表
 */
function init_SearchPanel(){
	var dicurl=jsonQueryUrl+'web.INSUDicDataCom'+SplCode+"GetDicJSONInfo"+SplCode+"TariType^^"	//ArgSpl
	var diccombox=$('#insuType').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'INDIDDicCode',   
	    textField:'INDIDDicDesc', 
        rownumbers:true,
        fit: true,
        pagination: false,
        url:"",
	    columns:[[   
	        {field:'INDIDDicCode',title:'代码',width:60},  
	        {field:'INDIDDicDesc',title:'描述',width:100}
	        
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
			if(data.rows.length>0){
				diccombox.combogrid('setValue',data.rows[0].INDIDDicCode)
			}
		}
	}); 
	diccombox.combogrid('grid').datagrid('options').url=dicurl;
	
	var BSYTypeurl=jsonQueryUrl+'web.INSUDicDataCom'+SplCode+"GetDicJSONInfo"+SplCode+"BSYType^^"	//ArgSpl
	var BSYTypecombox=$('#BSYType').combogrid({  
	    panelWidth:600,   
	    panelHeight:238,  
	    idField:'INDIDDicCode',   
	    textField:'INDIDDicDesc', 
        rownumbers:true,
        fit: true,
        pagination: false,
        url:"",
	    columns:[[   
	        {field:'INDIDDicCode',title:'代码',width:100},  
	        {field:'INDIDDicDesc',title:'描述',width:100},
	        {field:'INDIDDicBill1',title:'对象代码',width:150},
	        {field:'INDIDDicBill2',title:'对象描述',width:100}
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
		    if(data.rows.length>0){
				BSYTypecombox.combogrid('setValue',data.rows[0].INDIDDicCode)
			}
		},
		onSelect: function(rowIndex, rowData){
			//alert(rowIndex+"_"+rowData.INDIDDicBill1)
			if(rowData.INDIDDicBill1){
				QueryOEORD(rowData.INDIDDicBill1);
				Query();
			}else{
				trigthgrid.datagrid("loadData",{"total":"0",rows:[]})
			}
		}
	}); 
	BSYTypecombox.combogrid('grid').datagrid('options').url=BSYTypeurl;
	
	$('#QClase').combobox({   
	 	panelHeight:110, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '1',
			Desc: '按拼音'
		},{
			Code: '2',
			Desc: '按代码'
		},{
			Code: '3',
			Desc: '按名称'
		}]

	}); 

	$('#ConType').combobox({  
	    panelHeight:110, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: 'A',
			Desc: '查询所有'
		},{
			Code: 'Y',
			Desc: '查询已对照项'
		},{
			Code: 'N',
			Desc: '查询未对照项'
		}]

	}); 
}
function getSearchParam(){  
	return searchParam;  
}  

//查询模版数据
function Query(){
	tleftgrid.treegrid('unselectAll');
	//queryParams参数可以提交到后台通过FormCollection获取 也可以Request["ProductName"]=?获取
	//var tmpARGUS=ROOTID+SplCode+'INSUDICinfo'+SplCode+seldictype
	//asplp^1^CZZG^A^^
	var selHosDr=""
	if($("#_HospList").length>0){selHosDr=PUBLIC_CONSTANT.SESSION.HOSPID}
	var tmpARGUS=jsonQueryUrl+'web.INSUINFOTemplate'+SplCode+"GetConInfo"+SplCode+$('#insuType').combobox('getValue')+ArgSpl+""+ArgSpl+cspEscape($('#KeyWords').val())+ArgSpl+$('#ConType').combobox('getValue')+ArgSpl+$('#BSYType').combobox('getValue')+ArgSpl+$('#QClase').combobox('getValue')+ArgSpl+selHosDr
	//alert($('#KeyWords').val()+"_"+cspEncodeUTF8($('#KeyWords').val())+"_"+cspEscape($('#KeyWords').val()))
	selTarData=""
	
	tleftgrid.treegrid('options').url=tmpARGUS;
	tleftgrid.treegrid('options').queryParams.qid="1"
	tleftgrid.treegrid('reload');
	tleftgrid.treegrid('getPanel').focus();
	if(oecongrid) oecongrid.datagrid('loadData',{total:0,rows:[]})
	

}
//加载医嘱对象信息
function QueryOEORD(bsyval){
	
	//if((""==bsyval)||(null==bsyval)) return;
	//var tmpARGUS=jsonQueryUrl+'web.INSUINFOTemplate'+SplCode+"GetCol"+SplCode+cspEscape("web.INSUOEORDInfo");
	var tmpARGUS=jsonQueryUrl+'web.INSUINFOTemplate'+SplCode+"GetCol"+SplCode+cspEscape(bsyval);
	//alert($('#KeyWords').val()+"_"+cspEncodeUTF8($('#KeyWords').val())+"_"+cspEscape($('#KeyWords').val()))

	trigthgrid.datagrid('options').url=tmpARGUS;
	trigthgrid.datagrid('options').queryParams.qid="1"
	trigthgrid.datagrid('reload');
	trigthgrid.datagrid('getPanel').focus();
}
//查询对照数据
function QueryCon(leftselData){
	var tmpid;
	var tmpARGUS="";
	if(selTarData==""){
		tmpid="-1"
	}else{
		tmpid=leftselData.Rowid
		
	}	
	var selHosDr=""
	if($("#_HospList").length>0){selHosDr=PUBLIC_CONSTANT.SESSION.HOSPID}
	if((tmpid=="unfined")||(tmpid==""))tmpid="-1"
	tmpARGUS=jsonQueryUrl+'web.INSUINFOTemplate'+SplCode+"GetConInfo"+SplCode+$('#insuType').combobox('getValue')+ArgSpl+tmpid+ArgSpl+""+ArgSpl+""+ArgSpl+$('#BSYType').combobox('getValue')+ArgSpl+""+ArgSpl+selHosDr
	//alert($('#KeyWords').val()+"_"+cspEncodeUTF8($('#KeyWords').val())+"_"+cspEscape($('#KeyWords').val()))
	//oecongrid.datagrid('unselectAll')
	oecongrid.datagrid('options').url=tmpARGUS;
	oecongrid.datagrid('options').queryParams.qid="1"
	oecongrid.datagrid('reload');
	oecongrid.datagrid('getPanel').focus();
}
//增加记录
function ConAct(act){
	//alert(EditIndex)
	//if(0<EditIndex<1000){Save()};
	
	var lastIndex=0
	
	if(act.toString()=='insertRow'){
		var parid=""
		var subid=""
		var tmpPropType="STRING"
		var parRowid=""
		if(EditIndex<0){EditIndex=1000}
		var node = tleftgrid.treegrid('getSelected');
		if(node){
			parid=node.id
			EditIndex=parid+"1000"
			tmpPropType=""
			parRowid=node['Rowid']
		}
		tleftgrid.treegrid('append',{
			parent: parid,  // 节点有一个'id'值,定义是通过'idField'属性
			data: [{
				id: EditIndex,
				Rowid:'',
				ParRowid:parRowid,
				tplCode:'',
				tplDesc:'',
				PropType:tmpPropType
			}]
		});
	}

	//alert(oecongrid.datagrid('getRows').length-1)
	//lastIndex=tleftgrid.treegrid('getRows').length;  
	//EditIndex=lastIndex
	//getEditRow(EditIndex,'conActDate').val(GetToday())
	tleftgrid.treegrid('select', EditIndex);
	tleftgrid.treegrid('beginEdit',EditIndex);
	selTarData = '';
	//GetToday()
	
	/*
	$("input.datagrid-editable-input").keyup(function(k) { 
		if(k.keyCode==13){
			QueryINSUTarInfoNew() 
		}
		
	});

 	$("input.datagrid-editable-input").keyup(function(temp) { 
		if(event.keyCode==13){
			alert(oecongrid.datagrid('getChanges', "inserted"))
		}
 	});
	*/

	//$.messager.alert('提示','填写数据后请点击"保存记录"按钮');   
}
function hstEdit(row){
	//oecongrid.datagrid('beginEdit',row);
	
	$('#editcel').window('open')
	$('#editCode').val(GetOEORDCode(selcondata.OEORDCode))
	var ExtStrArr="^^^^";
	if((selcondata.ExtStr1!=null)&(selcondata.ExtStr1!=undefined)){
		ExtStrArr=selcondata.ExtStr1.split("|")
	}
	if(ExtStrArr.length>0){
		$('#editdef1').val(ExtStrArr[0])
		$('#editdef2').val(ExtStrArr[1])
		$('#editdef3').val(ExtStrArr[2])
	}
	
}
//确认并保存字段
function Save(){
	if(EditIndex<0)return;
	tleftgrid.treegrid('acceptChanges');
	tleftgrid.treegrid('endEdit', EditIndex);
	//var editrow=tleftgrid.treegrid('getRows')[EditIndex];
	var editrow=tleftgrid.treegrid('getSelected',EditIndex);
	if(!editrow){
		return;	
	}
	var Rowid=editrow['Rowid'] || '';
	var tplCode=editrow['tplCode'] || '';
	var tplDesc=editrow['tplDesc'] || '';
	var PropType=editrow['PropType'] || '';
	var ConFlag=editrow['ConFlag'] || '';
	var userID=session['LOGON.USERID'];
	var userName=session['LOGON.USERNAME'];
	var ConCode=editrow['OEORDCode'] || '';
	var ConDesc=editrow['OEORDDesc'] || '';
	var ExtStr1 = editrow['ExtStr1'] || '';
	//var ParRowid=tleftgrid.treegrid('getParent',EditIndex)['Rowid'];
	var ParRowid=editrow['ParRowid'];
	if((""==tplCode)||(undefined==tplCode)){
		$.messager.alert('提示','空数据无需保存','info');   
		tleftgrid.datagrid('deleteRow',EditIndex);
		return;
	}
	if($('#BSYType').combobox('getValue')==''){
		$.messager.alert('提示','业务类型不能为空','info');   
		tleftgrid.datagrid('deleteRow',EditIndex);
		return;
	}
	var selHosDr=""
	if($("#_HospList").length>0){selHosDr=PUBLIC_CONSTANT.SESSION.HOSPID}
	//if(confirm('  吗?')){
		//如果有乱码就用JS的cspEscape()函数加密
	    var UpdateStr=Rowid+"^"+$('#insuType').combobox('getValue')+"^"+$('#BSYType').combobox('getValue')+"^"+PropType+"^"+ParRowid+"^"+tplCode+"^"+tplDesc+"^"+ConCode+"^"+ConDesc+"^"+ExtStr1+"^^^^"
	    UpdateStr=UpdateStr.replace(undefined,"")
		var savecode=tkMakeServerCall("web.INSUINFOTemplate","SaveConInfo",UpdateStr,selHosDr)
		if(eval(savecode)>0){
			//$.messager.alert('提示','保存成功!'); 
			editrow['Rowid']=savecode;
			Query()
			alertPopover('提示','保存成功！',2000,'success')
		}else{
			$.messager.alert('提示','保存失败!','info');   
		}
	//}

}
//确认并保存数据
function SaveCon(rowIndex){
	//var editrow=tleftgrid.datagrid('getRows')[EditIndex];
	//var sconActDate=editrow['conActDate']
	if(rowIndex){
		$('#trightdg').datagrid('selectRow', rowIndex);
	}
	var userID=session['LOGON.USERID'];
	var userName=session['LOGON.USERNAME'];

	if((""==selTarData)||(""==selTarData.Rowid)||(undefined==seloeData.OECode)){
		$.messager.alert('提示','请选择要对照的记录!','info');   
		//tleftgrid.datagrid('deleteRow',EditIndex);
		//ConAct("insertRow")
		return false;
	}
	var selHosDr=""
	if($("#_HospList").length>0){selHosDr=PUBLIC_CONSTANT.SESSION.HOSPID}
	$.messager.confirm('提示','你确定要把 '+selTarData.tplDesc+' 对照成 '+seloeData.OEDesc+' 吗?',function(r){
			if(r){
				//如果有乱码就用JS的cspEscape()函数加密
			    var UpdateStr=selTarData.Rowid+"^"+$('#insuType').combobox('getValue')+"^"+$('#BSYType').combobox('getValue')+"^"+selTarData.PropType+"^"+selTarData.ParRowid+"^"+selTarData.tplCode+"^"+selTarData.tplDesc+"^"+Base64.encode(seloeData.OECode)+"^"+seloeData.OEDesc+"^||^^^^"
			    UpdateStr=UpdateStr.replace(undefined,"")
				var savecode=tkMakeServerCall("web.INSUINFOTemplate","SaveConInfo",UpdateStr,selHosDr)
				if(eval(savecode)>0){
					//$.messager.alert('提示','保存成功!');   
					alertPopover('提示','对照成功！',2000,'success')	
					tleftgrid.treegrid('reload');

				}else{
					$.messager.alert('提示','对照失败!','info');   
				}
				seloeData=""
				QueryCon(selTarData)
			}else{
				tleftgrid.datagrid('deleteRow',EditIndex);
				ConAct("insertRow")
				return false;	
			}
		}
	)

}
function SaveConEdit(){
	//var editrow=tleftgrid.datagrid('getRows')[EditIndex];
	//var sconActDate=editrow['conActDate']
	var userID=session['LOGON.USERID'];
	var userName=session['LOGON.USERNAME'];
	//oecongrid.treegrid('acceptChanges');
	//oecongrid.treegrid('endEdit', 0);
	//var OEORDCode=oecongrid.datagrid('getRows')[0]['OEORDCode']
	var selHosDr=""
	if($("#_HospList").length>0){selHosDr=PUBLIC_CONSTANT.SESSION.HOSPID}
	var OEORDCode=$('#editCode').val()
	var editdef=$('#editdef1').val()+"|"+$('#editdef2').val()+"|"+$('#editdef3').val();
	$.messager.confirm('提示','你确定要修改成:'+OEORDCode+' 吗?',function(r){
		if(r){
			if(OEORDCode!="")OEORDCode=Base64.encode(OEORDCode)
			//如果有乱码就用JS的cspEscape()函数加密
	    	var UpdateStr=selTarData.Rowid+"^"+$('#insuType').combobox('getValue')+"^"+$('#BSYType').combobox('getValue')+"^"+selTarData.PropType+"^"+selTarData.ParRowid+"^"+selTarData.tplCode+"^"+selTarData.tplDesc+"^"+OEORDCode+"^"+selcondata.OEORDDesc+"^"+editdef+"^^^^"
	    	UpdateStr=UpdateStr.replace(undefined,"")
			var savecode=tkMakeServerCall("web.INSUINFOTemplate","SaveConInfo",UpdateStr,selHosDr)
			//alert(UpdateStr+"_"+savecode)
			if(eval(savecode)>0){
				//$.messager.alert('提示','保存成功!');   
				alertPopover('提示','对照成功！',2000,'success')
				tleftgrid.treegrid('reload');
			}else{
				$.messager.alert('提示','对照失败!','info');   
			}
			seloeData=""
			QueryCon(selTarData)
		}else{
			//oecongrid.datagrid('beginEdit',EditIndex);
			tleftgrid.datagrid('deleteRow',EditIndex);
			ConAct("insertRow")
			return false;	
		}	
		$('#editcel').window('close')
	})
}
//删除对照
function DelCon(){
	var tmpdelid=""
	/*减少选择操作，直接用变量了
	var selectedCon =oecongrid.datagrid('getSelected');
	if (selectedCon){
		if(selectedCon.ConId!=""){
			tmpdelid=selectedCon.ConId
		}
	}	
	*/
	if(selcondata){tmpdelid=selcondata.Rowid}
	if((""!=selTarData)&(""==tmpdelid)){
		if(selTarData.ConFlag!="Y"){$.messager.alert('提示','未对照无需删除!','info');return;}
		tmpdelid=selTarData.Rowid
	}
	var selHosDr=""
	if($("#_HospList").length>0){selHosDr=PUBLIC_CONSTANT.SESSION.HOSPID}
	if(tmpdelid==""){$.messager.alert('提示','请选择要删除的记录!','info');return;}
	$.messager.confirm('请确认','你确定要删除这条对照吗?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.INSUINFOTemplate","DelConInfo",tmpdelid,selHosDr,"C")
			if(eval(savecode)>=0){
				//$.messager.alert('提示','删除成功!');  
				alertPopover('提示','删除成功！',2000,'success') 
				selcondata=""
				selTarData=""
			}else{
				$.messager.alert('提示','删除失败!','info');   
			}
			Query()
			ConGridQuery(selTarData)
		}else{
			return;	
		}
	});
	
}
//删除节点
function delTep(){
	var tmpdelid=""
	/*
	var selectedCon =oecongrid.datagrid('getSelected');
	if (selectedCon){
		if(selectedCon.ConId!=""){
			tmpdelid=selectedCon.ConId
		}
	}	
	*/
	if(selTarData){tmpdelid=selTarData.Rowid}
	if(tmpdelid==""){$.messager.alert('提示','请选择要删除的记录!','info');return;}
	//alert(tmpdelid)
	$.messager.confirm('请确认','你确定要删除这条信息吗?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.INSUINFOTemplate","DelConInfo",tmpdelid,"")
			//alert(savecode)
			if(eval(savecode)>=0){
				//$.messager.alert('提示','删除成功!');  
				alertPopover('提示','删除成功！',2000,'success');
			}else{
				var msg = '';
				switch (savecode){ 
				    case "-1" :
				    	var msg = '请先删除子节点';
				    	break;
				    default :
						msg = savecode;
				    	break;
				    }
				alertPopover('提示','删除失败: ' + msg ,2000,'error');   
			}
			Query()
			ConGridQuery(selTarData)
		}else{
			return;	
		}
	});
	
}
function getcombogridValue(){ 
	//var grid=$("#cc").combogrid("grid");//获取表格对象 
	//var row = grid.datagrid('getSelected');//获取行数据 
	//alert("选择的grid中的数据如下：code:"+row.code+" name:"+row.name+" addr:"+row.addr+" col4:"+row.col4); 
} 
//查询对照历史记录
function ConGridQuery(rowData){
	tleftgrid.datagrid('cancelEdit',EditIndex);
	selTarData = rowData;
	QueryCon(selTarData);
}

function getEditRow(lastIndex,field){  
	var tmptar=tleftgrid.treegrid('getEditor', {    
        index : lastIndex,    
        field : field  
	}).target; 
	//alert(tmptar) 
	return tmptar
}  
function getEditRownew(lastIndex){  
	var tmptar=tleftgrid.treegrid('getEditors',lastIndex);  
	return tmptar
}  
//对加密数据解密
function GetOEORDCode(value){
	if(null==value) return "";
	//if (value.length>20) return Base64.decode(value); else return value;
	return Base64.decode(value);
} 
//修改模板数据
function UpdateAct(){
	if(!selTarData){
		$.messager.alert('提示','未选择数据','info'); 
		return;	
	}
	var parid="";
	if(EditIndex<0){EditIndex=1000}
	var node = tleftgrid.treegrid('getSelected');
	if(node){
		parid=node.id;
		EditIndex=parid;
	}
	tleftgrid.treegrid('select', EditIndex);
	tleftgrid.treegrid('beginEdit',EditIndex);
}

function fixWidth(percent)  
{  
    return document.body.clientWidth * percent ;//根据自身情况更改

}
/*
 * 对照明细历史
 */
function init_oecdg(){
	oecongrid=$('#oecdg').datagrid({
		data: {"total":0,"rows":''},
		idField:'ConId',
		rownumbers:true,
		height: 150,
		border:false,
		fitColumns: false,
		striped:true,
		singleSelect: true,
		columns:[[
			{field:'Rowid',title:'Rowid',width:5,hidden:true},
			{field:'tplCode',title:'模版字段代码',width:100},
			{field:'tplDesc',title:'模版字段名称',width:100},
			{field: 'Option', title: '删除对照', width: 70
				,formatter:function(value,data,row){
					return "<a href='#' onclick='DelCon(\""+row+"\")'>\
					<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png ' border=0/>\
					</a>";
				}
			},
			{field:'OEORDCode',title:'对照代码',width:300,editor:{
				type:'text'	
			},formatter:function(value,row,index){
				return GetOEORDCode(value);}},
			{field:'OEORDDesc',title:'对照名称',width:100},
			{field:'ExtStr1',title:'默认设定',width:100},
			{field:'PropType',title:'字段类型',width:70},
			{field:'InsuType',title:'医保类型',width:70},
			{field:'ExtStr2',title:'扩展2',width:70},
			{field:'ExtStr3',title:'扩展3',width:70},
			{field:'ExtStr4',title:'扩展4',width:70},
			{field:'ExtStr5',title:'扩展5',width:70}
			
		]],
		pagination:false,
		onLoadSuccess:function(data){
			//oecongrid.datagrid('selectRecord',selTarData.ConId)
		},
		onDblClickRow : function(rowIndex, rowDatac) {
            //fillform(rowIndex,rowData)
            selcondata=rowDatac;
            //rowDatac.OEORDCode=GetOEORDCode(rowDatac.OEORDCode); //DingSH 20160523
            hstEdit(rowIndex)
        },
        onUnselect: function(rowIndex, rowDatac) {
	        //selTarid="";
        	//alert(rowIndex+"-"+rowData.itemid)
        	selcondata=""
        }
		
	});	
}
/*
 * 初始化医嘱对象列表
 */
function init_trightdg(){
	trigthgrid=$('#trightdg').datagrid({
		data: {"total":0,"rows":''},
		rownumbers:true,
		//width: 400,
		//height: 436,
		fit:true,
		striped:true,
		//fitColumns: true,
		singleSelect: true,
		frozenColumns:[[

		]],
		pagination:false,
		frozenColumns:[[
			{
				field: 'Con', title: '对照', width: 50
				,formatter:function(value,data,row){
					return "<a href='#' onclick='SaveCon(\""+row+"\")'>\
					<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png ' border=0/>\
					</a>";
				}
			}
		]],
		columns:[[
			
			{field:'OECode',title:'代码',width:150},
			{field:'OEDesc',title:'描述',width:150},
			{field:'OENote',title:'备注',width:100}
		]],
		onSelect : function(rowIndex, rowDatar) {
            //fillform(rowIndex,rowData)
            seloeData=rowDatar;
        },
        onUnselect: function(rowIndex, rowDatar) {
	        //selTarid="";
        	//alert(rowIndex+"-"+rowData.itemid)
        	seloeData=""
        },
		onLoadSuccess:function(data){
			//Query()
		},
		onDblClickRow:function(){
			SaveCon();
		}
	});
}
/*
 * 初始化模版的grid
 */
function init_tleftdg(){
	tleftgrid=$('#tleftdg').treegrid({
		data: {"total":0,"rows":''},
		iconCls: 'icon-save',
		rownumbers:true,
		idField:'id',
		treeField:'tplCode',
		height:500,
		striped:true,
		toolbar:'#allbar',
		//fitColumns: true,
		singleSelect: true,
		frozenColumns:[[
		]],
		pagination:false,
		fit:true,
		columns:[[
			{field:'Rowid',title:'Rowid',width:60,hidden:true},
			{field:'ParRowid',title:'ParRowid',width:60,hidden:true},
			{field:'tplCode',title:'代码',width:90,editor:{
				type:'text'	
			}},
			{field:'tplDesc',title:'描述',width:150,editor:{
				type:'text'	
			}},
			{field:'ExtStr1',title:'默认设定',width:80},
			{field:'PropType',title:'节点类型',width:80,editor:{
				type:'text'	
			}},
			{field:'ConFlag',title:'是否对照',width:80,formatter:function(value,data,row){
					if (value=="Y"){
						value="是";
					}else{value='否'}
					return value;
				}},
			{field:'OEORDCode',title:'对照代码',width:80,formatter:function(value,row,index){
				return GetOEORDCode(value);}},
			{field:'OEORDDesc',title:'对照名称',width:110}

		]],
		rowStyler: function(row){
		   if ('Y'==row.ConFlag){
				//return  'background-color:#FFE7BA;' ;
				return 'color:blue'
				}
			if ('LIST'==row.PropType){
				//return 'background-color:#FFFFFF;color:#DBDBDB;'
				return 'color:#1D741D';
			}
			
		},
        onClickRow : function(index,rowData) {
	        //alert(rowIndex,"_",rowData)
            ConGridQuery(rowData)
            //if($('#cked')[0].checked){ConAct("insertRow")}
        },
        onUnselect: function(index, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
        onCancelEdit:function(rowIndex, rowData){
	        if( !rowData.Rowid){
				tleftgrid.datagrid('deleteRow',EditIndex);
	        }
	        EditIndex = -2;
	    }
	});
}
/*
 * 自适应
 */
function init_layout(){
	$('#south-panel').panel('collapse');
	// 面板展开
	$('#south-panel').panel({
    	onCollapse:function(){
			resizeLayout('Collapse');
    	},
    	onExpand:function(){
	    	resizeLayout('Expand');
			
	    }
	});
}  
function alertPopover(title,info,time,typeval){
	$.messager.popover({msg: info,type:typeval,timeout: time});
}
/*
 * 对照明细自适应
 */
function resizeLayout(type){
	var height;
	var top ;
	if(type == 'Collapse'){
		height = window.document.body.offsetHeight - 164  - 50 - 35 + 'px'; // page - north - south(collapse) - tabs = dg height
		top =   window.document.body.offsetHeight   - 50 - 35  + 10 +'px'; // dg height + padding10px + north
		var rightHeight = window.document.body.offsetHeight - 122  - 50 - 35 + 85 + 'px';
		$('.center-panel').css('height',height);
		$('#coninfopanel-right').css('height',rightHeight);
		$('.layout-panel-south').css('top',top);
		$('#tleftdg').datagrid('resize');
		$('#trightdg').datagrid('resize');
	}else  if(type == 'Expand'){
		height = window.document.body.offsetHeight - 164  - 205 - 35 + 'px'; // page - north - south(Expand) - tabs = dg height
		top =   window.document.body.offsetHeight   - 205 - 35  + 10 +'px'; // dg height + padding10px + north
		var rightHeight = window.document.body.offsetHeight - 122  - 205 - 35 + 85 + 'px';
		$('#coninfopanel-right').css('height',rightHeight);
		$('.center-panel').css('height',height);
		$('.layout-panel-south').css('top',top);
		$('#tleftdg').datagrid('resize');
		$('#trightdg').datagrid('resize');
	}		
}
function selectHospCombHandle(){
	//$('#insuType').combobox('clear');
	$('#insuType').combogrid('grid').datagrid('reload');
	//$('#BSYType').combobox('clear');
	$('#BSYType').combogrid('grid').datagrid('reload');	
	Query();	
}
function Exportxls(){

	var selHosDr=""
	if($("#_HospList").length>0){selHosDr=PUBLIC_CONSTANT.SESSION.HOSPID}
	var tmpARGUS=jsonQueryUrl+'web.INSUINFOTemplate'+SplCode+"GetConInfo"+SplCode+$('#insuType').combobox('getValue')+ArgSpl+""+ArgSpl+cspEscape($('#KeyWords').val())+ArgSpl+$('#ConType').combobox('getValue')+ArgSpl+$('#BSYType').combobox('getValue')+ArgSpl+$('#QClase').combobox('getValue')+ArgSpl+selHosDr
	
	ExportTitle="序号(非空)^RowID(新增时为空)^模版字段代码^模版字段名称^对照代码^对照名称^模版字段类型^医保类型^对照标志^父节点Rowid^父节点序号^^业务类型^预留1^预留2^预留3^预留4^预留5^HospitalDr^^^^"
	ExportPrompt(tmpARGUS)	
}
//导入文件功能
//hisui没有导入功能,暂时用post提交,内容解析在后台
function importxls(){
	if($('#_efinput').length != 0){$('#_efinput').val("");$("#_efinput").empty();$("#_efinput").remove();}
	var inputObj=document.createElement('input')
	inputObj.setAttribute('id','_efinput');
	inputObj.setAttribute('type','file');
	inputObj.setAttribute("style",'visibility:hidden');
	document.body.appendChild(inputObj);
	inputObj.addEventListener("change", 
	function(){
	    var file = inputObj.files[0];
	    var form = new FormData();
	    form.append("FileStream", file); //第一个参数是后台读取的请求key值
	    form.append("fileName", file.name);
	    $.ajax({
	        url:jsonQueryUrl+'web.INSUINFOTemplate'+SplCode+"Importfromcsv"+SplCode,
	        type:'post',
	        data: form,
	        contentType: false,
	        processData: false,
	        success:function(res){
	            console.log(res);
	            if(eval(res)=="1"){
		            alertPopover('提示','导入完毕！',2000,'success');
		        }else{
					alertPopover('提示','导入失败: ' + res,2000,'error');   
				}
				Query()
	        }
	    })
	  },false);
	inputObj.click();
}
