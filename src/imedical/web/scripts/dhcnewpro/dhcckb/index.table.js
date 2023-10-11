/**
	zhouxin
	2019-06-28
*/
var condArray= [{ "value": "and", "text": "����" },{ "value": "or", "text": "����" }]; //�߼���ϵ
var curCondRow=1;
var stateBoxArray= [{ "val": "=", "text": "����" },{ "val": ">", "text": "����" },{ "val": ">=", "text": "���ڵ���" },{ "val": "<=", "text": "С�ڵ���" },{ "val": "<", "text": "С��" }]; //����
$(function(){
	initCrumbs();
	initDataGrid();
	initCombobox();
	initButton();
})

function initCrumbs(){
	
	var catId=$("#catId").val(),crumbHtml=getCrumbs(catId,"","");
	///��֯��̬��ѯ����
	crumbHtml = crumbHtml+'<div><span style="margin:0 10 0 10"><span onclick="toggleExecInfo(this);" class="toggle-btn">�����ѯ</span></span>'
	crumbHtml = crumbHtml+'<span><a href="#" class="hisui-linkbutton"  iconCls="icon-w-find" id="serchtbdt" >��ѯ</a></span></div>'
	crumbHtml = crumbHtml+'<table style="display:none" id="condTable"></table></div>'
	$("#tableTb").html(crumbHtml);
	addCondition();
}
// ����¼�
function toggleExecInfo(obj){
	
	if($(obj).hasClass("expanded")){
		$(obj).removeClass("expanded");
		$(obj).html("�����ѯ");
		$("#condTable").hide();
		$("#dashline").hide();
		
	}else{
		$(obj).addClass("expanded");
		$(obj).html("����");
		$("#condTable").show();
		$("#dashline").show();
	}
	//setHeight();
}
///���ø߶�
function setHeight(){
    var tableHeight=$('#condTable')[0].offsetHeight
    var divHeight=tableHeight+150;
    var centertop=divHeight+50;
    var maindgHeight=$(window).height()-divHeight-130;
}
// ������
function addCondition(){
	curCondRow=curCondRow+1;
	var html=""
	html+='<tr id="'+curCondRow+'Tr"><td><b style="padding-left:10px;padding-right:10px;">��ѯ����</b>';
	html+=getLookUpHtml(curCondRow,1);
	//html+=getSelectHtml(curCondRow,1);
	html+='<span style="padding-left:20px;" ><b>����</b></span>'
	html+='<span style="padding-left:20px;" ><input id="QueCond'+curCondRow+"-"+1+'" style="width:120" class="easyui-combobox"/></span>';
	html+='<span style="padding-left:20px;" id="condTd">�߼���ϵ<input id="condCombox'+curCondRow+"-"+1+'" style="width:70"/></span>'
	html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="addCondition()"><span  class="icon icon-add" >&nbsp;&nbsp;&nbsp;&nbsp;</span>������</span></td>>';
	if(curCondRow>2){
		html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="removeCond('+curCondRow+')"><span  class="icon icon-remove" >&nbsp;&nbsp;&nbsp;&nbsp;</span>ɾ����</span></td></tr>';
	}
	$("#condTable").append(html);
	//����
	$("input[id^=stateBox"+curCondRow+"-]").combobox({
		panelHeight:"auto", 
		data:stateBoxArray
	});
	//����ֵ
	$("input[id^=LookUp"+curCondRow+"-]").combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCCKKBIndex&MethodName=QueryDrugAttr',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option) {
			var netxId=this.id.split("LookUp")[1];
			var unitUrl = $URL+"?ClassName=web.DHCCKKBIndex&MethodName=QueryAttrData&Parref="+option.value
			$("input[id=QueCond"+netxId+"]").combobox('reload',unitUrl);
		}
		
	})
	$("input[id^=QueCond"+curCondRow+"-]").combobox({
		url:'',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option) {
			
			
		}
	})
	//�߼���ϵ
	$("input[id^=condCombox"+curCondRow+"-]").combobox({
		panelHeight:"auto", 
		data:condArray
	});
	//setHeight();
}
// ɾ����
function removeCond(row){
	$("#"+row+"Tr").remove();
}
// ��ѯ���� ��������
function getLookUpHtml(row,column){
	var html="";
	var key=row+"-"+column;
	html+='<span>'
	html+='<input id="LookUp'+key+'" style="width:120;" class="easyui-combobox" />'	
	html+='</span>'
	return html;
}
// �������
function getSelectHtml(row,column){
	var key=row+"-"+column;
	var html='<span style="padding-left:20px;">';
	html+='<input  id="stateBox'+key+'" style="width:80;" class="easyui-combobox" />'
	html+='</span>'
	return html;
}
function initCombobox(){
	
}
///��ʼ����ť
function initButton(){
	$("#addCondBTN").on('click',addCondition); // �߼���ѯ��������
	
	$("#serchtbdt").on('click',query); // �߼���ѯ��������
	
}
function initDataGrid(){
	
	var columns=[[ 
			/*{field:'dic',hidden:true},
			{field:'incDesc',title:'��Ʒ��',width:150,align:'center',formatter:FormatterIncName},
			{field:'GenerName',title:'ͨ����',width:50,align:'center'},
			{field:'3',title:'���',width:50,align:'center'},
			{field:'FormType',title:'����',width:50,align:'center'},
			{field:'Manufacturer',title:'������ҵ',width:50,align:'center'},
			{field:'Ingredient',title:'�ɷ�',width:50,align:'center'},	// ,sortable :true
			{field:'6',title:'��׼�ĺ�',width:50,align:'center'},
			{field:'7',title:'У׼����',width:50,align:'center'}*/
			{field:'GenerName',title:'ͨ������',width:50,align:'center'},
			{field:'incDesc',title:'��Ʒ����',width:150,align:'center',formatter:FormatterIncName},
			{field:'Indication',title:'���',width:50,align:'center'},
			{field:'FormType',title:'����',width:50,align:'center'},
			{field:'AproNum',title:'��׼�ĺ�',width:50,align:'center'},
			{field:'Ingredient',title:'�ɷ�',width:50,align:'center'},	// ,sortable :true
			{field:'Manufacturer',title:'����',width:70,align:'center'},
			{field:'HospUsed',title:'��Ժ����',width:40,align:'center'}
			//{field:'7',title:'У׼����',width:50,align:'center',hidden:true}	
		 ]];
		 
	$('#datagrid').datagrid({
		toolbar:"#tableTb",  //kml 2020-03-06 add 'userInfo'
		url:LINK_CSP+"?ClassName=web.DHCCKKBIndex&MethodName=List&queryCat="+$("#catId").val()+"&userInfo="+userInfo+"&code="+$("#code").val(), 
		columns:columns,
		headerCls:'panel-header-gray', 
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		striped: false, 
		pagination:true,
		rownumbers:true,
		//sortName : 'CDCode',
		//remoteSort:false, 
        //sortOrder : 'desc',
		pageSize:15,
		pageList:[15,60,90],
		onBeforeLoad:function(param){
             param.queryCat=$("#catId").val();
        },
        onLoadSuccess: function(data) {
	       
			//window.parent.resize();	
        }
	});	
}

function FormatterIncName(value,row){
	return "<a href='javascript:void(0);' onclick='goCrumbWiki("+row.id+","+$("#catId").val()+")' style='cursor: pointer;text-decoration:none;'>"+value+"</a>"
}
///��ѯ
function query()
{
	var parStr=getParStr()
	$('#datagrid').datagrid('load',{"queryCat":$("#catId").val(),"parStr":parStr}); 
}
function getParStr(){
	var retArr=[];
	var cond=""  //$("#condCombox").combobox('getValue');
	$("#condTable").find("td").each(function(index,obj){
		if($(obj).children().length<3){
			return true;
		}
		// ��������ֵ������ ���룩
		var column=$(obj).children().eq(1).find("input")[2];
		if(column!=undefined){
			column=column.value;
		}else{
			column="";
		}
		if(column==""){
			return true;	
		}
		
		// �����ж�ֵ ����������ݣ�
		var columnValue=$(obj).children().eq(3).find("input")[2];
		if(columnValue!=undefined){
			columnValue=columnValue.value;
		}else{
			columnValue="";
		}
		if(columnValue==""){
			return true;	
		}
		// ȡ�߼���ϵ
		var oper=$(obj).children().eq(4).find("input")[2];
		if(oper!=undefined){
			oper=oper.value;
		}else{
			oper="";
		}
		// ��_$c(1)_ֵ_$c(1)_�ж�����_$c(1)_�߼���ϵ
		var par=column;
		par+="$"+columnValue;
		par+="$"+oper;
		//par+="$"+cond;
		retArr.push(par);
	})
	return retArr.join("^");
}