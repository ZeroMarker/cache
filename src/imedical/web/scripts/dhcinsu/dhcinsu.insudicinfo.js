/*
 * FileName:	dhcinsu.insudicinfo.js
 * Creator:		Chenyq
 * Date:		2021-12-23
 * MainJS:      dhcinsu.insuservqry.js
 * Description: �ֵ���ѯ-1901
 */
  var fileData=[];
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
	//setValueById('queryDate',getDefStDate(0));
	InsuDateDefault('queryDate');	
	// ҽ������
	init_dicINSUType();
	//click�¼�
	init_regClick();
	//��ʼ���ֵ���ѯ��¼dg	
	init_insudicdg(); 
	// ��ѯ��Ϣ������
	init_QueryPanel();
	
});


/**
*��ʼ��click�¼�
*/		
function init_regClick()
{
	 //���� + 20220923  LuJH
	 $("#btnExport").click(btnExport_Click);
	 //��ѯ
	 $("#btnDicQry").click(DicQry_Click);
  
}
	
/**
*�ֵ���ѯ
*/	
function DicQry_Click()
{
	var ExpStr=""  
	//var parentValue=getValueById('parentValue');
	//if(parentValue == "")
	//{
	//	$.messager.alert("��ܰ��ʾ","���ֵ��ֵ����Ϊ��!", 'info');
	//	return ;
	//}
	var admdvs=getValueById('admdvs');
	if(admdvs=="")
	{
		$.messager.alert("��ܰ��ʾ","������������Ϊ��!", 'info');
		return ;
	}
	
	var outPutObj=getDicInfo();
	if(!outPutObj){return ;}
	fileData=outPutObj.list
	if (outPutObj.list.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ���ֵ��¼!", 'info');return ;}
	loadQryGrid("insudicdg",outPutObj.list);
}

///�ֵ���ѯ-1901
function getDicInfo()
{
	
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('dicINSUType')+"^"+"1901"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"type",getValueById('dicType'));
	QryParams=AddQryParam(QryParams,"parentValue",getValueById('parentValue'));
	QryParams=AddQryParam(QryParams,"admdvs",getValueById('admdvs'));
	QryParams=AddQryParam(QryParams,"date",GetInsuDateFormat(getValueById('queryDate')));
	QryParams=AddQryParam(QryParams,"vali_Flag",getValueById('valiFlag'));
	QryParams=AddQryParam(QryParams,"page_num",getValueById('pageNum'));
	QryParams=AddQryParam(QryParams,"page_size",getValueById('pageSize'));
	QryParams=AddQryParam(QryParams,"insuplc_admdvs",GV.INSUPLCADMDVS);
	ExpStr=ExpStr+"^"+QryParams
	var rtn=InsuServQry(0,GV.USERID,ExpStr); 
	if (!rtn){return ;}
	if (rtn.split("^")[0]!="0") 
	 {
		$.messager.alert("��ʾ","��ѯʧ��!rtn="+rtn, 'error');
		return ;
	}
	 var outPutObj=JSON.parse(rtn.split("^")[1]);
	return outPutObj;
}
/*
 * datagrid
 */
function init_insudicdg() {
	var dgColumns = [[
			{field:'sort',title:'���',width:79},
			{field:'type',title:'�ֵ�����',width:200},
			{field:'label',title:'�ֵ��ǩ',width:200},	
			{field:'value',title:'�ֵ��ֵ',width:100},
			{field:'parent_value',title:'���ֵ��ֵ',width:100},
			{field:'valiFlag',title:'Ȩ�ޱ�ʶ',width:150},
			{field:'createUser',title:'�����˻�',width:100},
			{field:'create_date',title:'����ʱ��',width:280,formatter: function(value,row,index){
		     	 return timeCycle(value);     
			}},			
			{field:'version',title:'�汾��',width:200},
			
		]];

	// ��ʼ��DataGrid
	$('#insudicdg').datagrid({
		fit:true,
		border:false,
		data:[],
		//striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		}
	});
}

/*
 * ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
 */
function init_dicINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('dicINSUType','DLLType',Options); 	
	$('#dicINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('dicINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		}
 
	})	;
	
}

/* 
 * ��ʼ����ѯ���
 */
function init_QueryPanel(){
	// ��Ч��־
	$('#valiFlag').combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{
    			"id" : '1',
    			"text":"��Ч",
    			selected:true
    		},{
    			"id" : '0',
    			"text":"��Ч"	
    		}]	
	});
	
}

/* 
 * ʱ���ʽת��
 */
function timeCycle(time){
		//var time = 1624877371000;
		//var commonTime = unixTimestamp.toLocaleString();
		var unixTimestamp = new Date(time);
		var year=unixTimestamp.getFullYear();
		var month=unixTimestamp.getMonth()+1;
		var date=unixTimestamp.getDate();
		var hour=unixTimestamp.getHours();
		var minute=unixTimestamp.getMinutes();
		var second=unixTimestamp.getSeconds(); 
		if (month<10){month="0"+month}
		if (date<10){date="0"+date}
		if (hour<10){hour="0"+hour}
		if (minute<10){minute="0"+minute}
		if (second<10){second="0"+second}
		var commonTime=year+"-"+month+"-"+date+" "+hour+":"+minute+":"+second;
		return commonTime;
	 }





/**
*����
*/
function btnExport_Click(){
	
	 if (fileData.length==0){
		$.messager.popover({msg:'���Ȳ�ѯ�����ٵ���!',type:'info'});
		return ;
	 }
	//JSONToCSVConvertor(fileData, getValueById('type')+'�ֵ䵼��',"Ȩ�ޱ�ʶ,�����˻�,�ֵ��ǩ,���,����ʱ��,�ֵ�����,���ֵ��ֵ,�ֵ��ֵ,�汾��")
	jsonToExcel(fileData, "Ȩ�ޱ�ʶ,�����˻�,�ֵ��ǩ,���,����ʱ��,�ֵ�����,���ֵ��ֵ,�ֵ��ֵ,�汾��",getValueById('type')+"�ֵ䵼��")  //dhcinsu.common.js
}



