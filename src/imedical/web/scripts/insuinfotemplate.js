/**
 * ҽ�������ϴ���Ϣά��JS
 * Zhan 20160420
 * �汾��V1.0
 * easyui�汾:1.3.2
 */
var cmenu;
var tleftgrid;
var oecongrid;
var selTarData="";
var seloeData=""
var selcondata="";
//var ROOTID='TEST2';	//������
var searchParam = {}; 
var seldictype=""; 
var QParam="";
var EditIndex=-2
$(function(){
	
	GetjsonQueryUrl();

	// �����б�
	init_SearchPanel();
	
	// ��ʼ��ģ���grid
	init_tleftdg();

	// ��ʼ��ҽ�������б�
	init_trightdg();
	
	// ������ϸ��ʷ
	init_oecdg();
	
	//����
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
 * �����б�
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
	        {field:'INDIDDicCode',title:'����',width:60},  
	        {field:'INDIDDicDesc',title:'����',width:100}
	        
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
	        {field:'INDIDDicCode',title:'����',width:100},  
	        {field:'INDIDDicDesc',title:'����',width:100},
	        {field:'INDIDDicBill1',title:'�������',width:150},
	        {field:'INDIDDicBill2',title:'��������',width:100}
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
			Desc: '��ƴ��'
		},{
			Code: '2',
			Desc: '������'
		},{
			Code: '3',
			Desc: '������'
		}]

	}); 

	$('#ConType').combobox({  
	    panelHeight:110, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: 'A',
			Desc: '��ѯ����'
		},{
			Code: 'Y',
			Desc: '��ѯ�Ѷ�����'
		},{
			Code: 'N',
			Desc: '��ѯδ������'
		}]

	}); 
}
function getSearchParam(){  
	return searchParam;  
}  

//��ѯģ������
function Query(){
	tleftgrid.treegrid('unselectAll');
	//queryParams���������ύ����̨ͨ��FormCollection��ȡ Ҳ����Request["ProductName"]=?��ȡ
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
//����ҽ��������Ϣ
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
//��ѯ��������
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
//���Ӽ�¼
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
			parent: parid,  // �ڵ���һ��'id'ֵ,������ͨ��'idField'����
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

	//$.messager.alert('��ʾ','��д���ݺ�����"�����¼"��ť');   
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
//ȷ�ϲ������ֶ�
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
		$.messager.alert('��ʾ','���������豣��','info');   
		tleftgrid.datagrid('deleteRow',EditIndex);
		return;
	}
	if($('#BSYType').combobox('getValue')==''){
		$.messager.alert('��ʾ','ҵ�����Ͳ���Ϊ��','info');   
		tleftgrid.datagrid('deleteRow',EditIndex);
		return;
	}
	var selHosDr=""
	if($("#_HospList").length>0){selHosDr=PUBLIC_CONSTANT.SESSION.HOSPID}
	//if(confirm('  ��?')){
		//������������JS��cspEscape()��������
	    var UpdateStr=Rowid+"^"+$('#insuType').combobox('getValue')+"^"+$('#BSYType').combobox('getValue')+"^"+PropType+"^"+ParRowid+"^"+tplCode+"^"+tplDesc+"^"+ConCode+"^"+ConDesc+"^"+ExtStr1+"^^^^"
	    UpdateStr=UpdateStr.replace(undefined,"")
		var savecode=tkMakeServerCall("web.INSUINFOTemplate","SaveConInfo",UpdateStr,selHosDr)
		if(eval(savecode)>0){
			//$.messager.alert('��ʾ','����ɹ�!'); 
			editrow['Rowid']=savecode;
			Query()
			alertPopover('��ʾ','����ɹ���',2000,'success')
		}else{
			$.messager.alert('��ʾ','����ʧ��!','info');   
		}
	//}

}
//ȷ�ϲ���������
function SaveCon(rowIndex){
	//var editrow=tleftgrid.datagrid('getRows')[EditIndex];
	//var sconActDate=editrow['conActDate']
	if(rowIndex){
		$('#trightdg').datagrid('selectRow', rowIndex);
	}
	var userID=session['LOGON.USERID'];
	var userName=session['LOGON.USERNAME'];

	if((""==selTarData)||(""==selTarData.Rowid)||(undefined==seloeData.OECode)){
		$.messager.alert('��ʾ','��ѡ��Ҫ���յļ�¼!','info');   
		//tleftgrid.datagrid('deleteRow',EditIndex);
		//ConAct("insertRow")
		return false;
	}
	var selHosDr=""
	if($("#_HospList").length>0){selHosDr=PUBLIC_CONSTANT.SESSION.HOSPID}
	$.messager.confirm('��ʾ','��ȷ��Ҫ�� '+selTarData.tplDesc+' ���ճ� '+seloeData.OEDesc+' ��?',function(r){
			if(r){
				//������������JS��cspEscape()��������
			    var UpdateStr=selTarData.Rowid+"^"+$('#insuType').combobox('getValue')+"^"+$('#BSYType').combobox('getValue')+"^"+selTarData.PropType+"^"+selTarData.ParRowid+"^"+selTarData.tplCode+"^"+selTarData.tplDesc+"^"+Base64.encode(seloeData.OECode)+"^"+seloeData.OEDesc+"^||^^^^"
			    UpdateStr=UpdateStr.replace(undefined,"")
				var savecode=tkMakeServerCall("web.INSUINFOTemplate","SaveConInfo",UpdateStr,selHosDr)
				if(eval(savecode)>0){
					//$.messager.alert('��ʾ','����ɹ�!');   
					alertPopover('��ʾ','���ճɹ���',2000,'success')	
					tleftgrid.treegrid('reload');

				}else{
					$.messager.alert('��ʾ','����ʧ��!','info');   
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
	$.messager.confirm('��ʾ','��ȷ��Ҫ�޸ĳ�:'+OEORDCode+' ��?',function(r){
		if(r){
			if(OEORDCode!="")OEORDCode=Base64.encode(OEORDCode)
			//������������JS��cspEscape()��������
	    	var UpdateStr=selTarData.Rowid+"^"+$('#insuType').combobox('getValue')+"^"+$('#BSYType').combobox('getValue')+"^"+selTarData.PropType+"^"+selTarData.ParRowid+"^"+selTarData.tplCode+"^"+selTarData.tplDesc+"^"+OEORDCode+"^"+selcondata.OEORDDesc+"^"+editdef+"^^^^"
	    	UpdateStr=UpdateStr.replace(undefined,"")
			var savecode=tkMakeServerCall("web.INSUINFOTemplate","SaveConInfo",UpdateStr,selHosDr)
			//alert(UpdateStr+"_"+savecode)
			if(eval(savecode)>0){
				//$.messager.alert('��ʾ','����ɹ�!');   
				alertPopover('��ʾ','���ճɹ���',2000,'success')
				tleftgrid.treegrid('reload');
			}else{
				$.messager.alert('��ʾ','����ʧ��!','info');   
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
//ɾ������
function DelCon(){
	var tmpdelid=""
	/*����ѡ�������ֱ���ñ�����
	var selectedCon =oecongrid.datagrid('getSelected');
	if (selectedCon){
		if(selectedCon.ConId!=""){
			tmpdelid=selectedCon.ConId
		}
	}	
	*/
	if(selcondata){tmpdelid=selcondata.Rowid}
	if((""!=selTarData)&(""==tmpdelid)){
		if(selTarData.ConFlag!="Y"){$.messager.alert('��ʾ','δ��������ɾ��!','info');return;}
		tmpdelid=selTarData.Rowid
	}
	var selHosDr=""
	if($("#_HospList").length>0){selHosDr=PUBLIC_CONSTANT.SESSION.HOSPID}
	if(tmpdelid==""){$.messager.alert('��ʾ','��ѡ��Ҫɾ���ļ�¼!','info');return;}
	$.messager.confirm('��ȷ��','��ȷ��Ҫɾ������������?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.INSUINFOTemplate","DelConInfo",tmpdelid,selHosDr,"C")
			if(eval(savecode)>=0){
				//$.messager.alert('��ʾ','ɾ���ɹ�!');  
				alertPopover('��ʾ','ɾ���ɹ���',2000,'success') 
				selcondata=""
				selTarData=""
			}else{
				$.messager.alert('��ʾ','ɾ��ʧ��!','info');   
			}
			Query()
			ConGridQuery(selTarData)
		}else{
			return;	
		}
	});
	
}
//ɾ���ڵ�
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
	if(tmpdelid==""){$.messager.alert('��ʾ','��ѡ��Ҫɾ���ļ�¼!','info');return;}
	//alert(tmpdelid)
	$.messager.confirm('��ȷ��','��ȷ��Ҫɾ��������Ϣ��?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.INSUINFOTemplate","DelConInfo",tmpdelid,"")
			//alert(savecode)
			if(eval(savecode)>=0){
				//$.messager.alert('��ʾ','ɾ���ɹ�!');  
				alertPopover('��ʾ','ɾ���ɹ���',2000,'success');
			}else{
				var msg = '';
				switch (savecode){ 
				    case "-1" :
				    	var msg = '����ɾ���ӽڵ�';
				    	break;
				    default :
						msg = savecode;
				    	break;
				    }
				alertPopover('��ʾ','ɾ��ʧ��: ' + msg ,2000,'error');   
			}
			Query()
			ConGridQuery(selTarData)
		}else{
			return;	
		}
	});
	
}
function getcombogridValue(){ 
	//var grid=$("#cc").combogrid("grid");//��ȡ������ 
	//var row = grid.datagrid('getSelected');//��ȡ������ 
	//alert("ѡ���grid�е��������£�code:"+row.code+" name:"+row.name+" addr:"+row.addr+" col4:"+row.col4); 
} 
//��ѯ������ʷ��¼
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
//�Լ������ݽ���
function GetOEORDCode(value){
	if(null==value) return "";
	//if (value.length>20) return Base64.decode(value); else return value;
	return Base64.decode(value);
} 
//�޸�ģ������
function UpdateAct(){
	if(!selTarData){
		$.messager.alert('��ʾ','δѡ������','info'); 
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
    return document.body.clientWidth * percent ;//���������������

}
/*
 * ������ϸ��ʷ
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
			{field:'tplCode',title:'ģ���ֶδ���',width:100},
			{field:'tplDesc',title:'ģ���ֶ�����',width:100},
			{field: 'Option', title: 'ɾ������', width: 70
				,formatter:function(value,data,row){
					return "<a href='#' onclick='DelCon(\""+row+"\")'>\
					<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png ' border=0/>\
					</a>";
				}
			},
			{field:'OEORDCode',title:'���մ���',width:300,editor:{
				type:'text'	
			},formatter:function(value,row,index){
				return GetOEORDCode(value);}},
			{field:'OEORDDesc',title:'��������',width:100},
			{field:'ExtStr1',title:'Ĭ���趨',width:100},
			{field:'PropType',title:'�ֶ�����',width:70},
			{field:'InsuType',title:'ҽ������',width:70},
			{field:'ExtStr2',title:'��չ2',width:70},
			{field:'ExtStr3',title:'��չ3',width:70},
			{field:'ExtStr4',title:'��չ4',width:70},
			{field:'ExtStr5',title:'��չ5',width:70}
			
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
 * ��ʼ��ҽ�������б�
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
				field: 'Con', title: '����', width: 50
				,formatter:function(value,data,row){
					return "<a href='#' onclick='SaveCon(\""+row+"\")'>\
					<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png ' border=0/>\
					</a>";
				}
			}
		]],
		columns:[[
			
			{field:'OECode',title:'����',width:150},
			{field:'OEDesc',title:'����',width:150},
			{field:'OENote',title:'��ע',width:100}
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
 * ��ʼ��ģ���grid
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
			{field:'tplCode',title:'����',width:90,editor:{
				type:'text'	
			}},
			{field:'tplDesc',title:'����',width:150,editor:{
				type:'text'	
			}},
			{field:'ExtStr1',title:'Ĭ���趨',width:80},
			{field:'PropType',title:'�ڵ�����',width:80,editor:{
				type:'text'	
			}},
			{field:'ConFlag',title:'�Ƿ����',width:80,formatter:function(value,data,row){
					if (value=="Y"){
						value="��";
					}else{value='��'}
					return value;
				}},
			{field:'OEORDCode',title:'���մ���',width:80,formatter:function(value,row,index){
				return GetOEORDCode(value);}},
			{field:'OEORDDesc',title:'��������',width:110}

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
 * ����Ӧ
 */
function init_layout(){
	$('#south-panel').panel('collapse');
	// ���չ��
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
 * ������ϸ����Ӧ
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
	
	ExportTitle="���(�ǿ�)^RowID(����ʱΪ��)^ģ���ֶδ���^ģ���ֶ�����^���մ���^��������^ģ���ֶ�����^ҽ������^���ձ�־^���ڵ�Rowid^���ڵ����^^ҵ������^Ԥ��1^Ԥ��2^Ԥ��3^Ԥ��4^Ԥ��5^HospitalDr^^^^"
	ExportPrompt(tmpARGUS)	
}
//�����ļ�����
//hisuiû�е��빦��,��ʱ��post�ύ,���ݽ����ں�̨
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
	    form.append("FileStream", file); //��һ�������Ǻ�̨��ȡ������keyֵ
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
		            alertPopover('��ʾ','������ϣ�',2000,'success');
		        }else{
					alertPopover('��ʾ','����ʧ��: ' + res,2000,'error');   
				}
				Query()
	        }
	    })
	  },false);
	inputObj.click();
}
