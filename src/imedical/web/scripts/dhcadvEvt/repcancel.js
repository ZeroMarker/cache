
/// Creator: congyue
/// CreateDate: 2017-07-28
/// Descript: �����¼����� ���ϲ�ѯ����
var url = "dhcadv.repaction.csp";
var StrParam="";
var StDate="";  //formatDate(-7);  //һ��ǰ������   2018-01-26 �޸ģ�Ĭ�Ͽ�ʼ����Ϊ����ʹ�����ڣ���2018-01-01
var EndDate=""; //ϵͳ�ĵ�ǰ����
var querytitle="" ;
var ColSort="",ColOrder=""; // ������ , �����־:desc ����   asc ����
$(function(){ 
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPageButton();         /// ���水ť����
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	InitPageStyle();          /// ��ʼ��ҳ����ʽ		
});
/// ��ʼ������ؼ�����
function InitPageComponent(){
	$.messager.defaults = { ok: $g("ȷ��"),cancel: $g("ȡ��")};
	runClassMethod("web.DHCADVCOMMON","GetStaEndDate",{'LgParam':LgParam},function(data){
		var tmp=data.split("^"); 
		StDate=tmp[0];
		EndDate=tmp[1];
	},'',false);

	$("#stdate").datebox("setValue",StDate);  //Init��ʼ����
	$("#enddate").datebox("setValue",EndDate);  //Init��������
	//����
   $('#dept').combobox({ //  yangyongtao   2017-11-17
		url:url+'?action=GetAllLocNewVersion&hospId='+LgHospID,
		mode:'remote',  //���������������
		onShowPanel:function(){ 
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
	});
	if(LgGroupDesc!="����"){
		$('#dept').combobox("setValue",LgCtLocID);     //����ID
		//$("#dept").combobox('setText',LgCtLocDesc);
	}
	//��������
	$('#typeevent').combobox({
		url:url+'?action=SelEventbyNew&param='+LgParam
	});
}	
/// ���水ť����
function InitPageButton(){
	$('#Refresh').bind("click",Query);  //ˢ��
	$('#Find').bind("click",Query);  //�����ѯ 
	$('#Printhtml').bind("click",htmlPrint);  //�����ӡ  Print ʹ��html��ӡ
	$('#Export').bind("click",Export);  //�������(��̬����)
	$('#ExportAll').bind("click",ExportAll);  //�������(ȫ�����͹̶�����)
	$('#ExportWord').bind("click",ExportWordFile);  //�������(word����)	
	$("#Print").bind("click",Print);		 //�����Ĵ�ӡ
}
/// ��ʼ��ҳ����ʽ
function InitPageStyle(){
	$("#reqList").height($(window).height()-245)//hxy 08-28 st
	$("#maindg").datagrid('resize', {           
            height : $(window).height()-245
    }); 
    window.onresize=resizeH;                    //hxy 08-28 ed
}
//����Ӧ hxy 2017-08-28
function resizeH(){
	$("#reqList").height($(window).height()-245)
	$("#maindg").datagrid('resize', { 
            height : $(window).height()-245
    }); 
}
//��ʼ��ҳ��datagrid
function InitPageDataGrid()
{
	//����columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"RepID",title:'RepID',width:80,hidden:true},
		{field:"recordID",title:'recordID',width:80,hidden:true},
		{field:'RepShareStatus',title:$g('����״̬'),width:80,align:'center',hidden:true},
		{field:'Edit',title:$g('�鿴'),width:50,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:'StatusLast',title:$g('��һ״̬'),width:100,hidden:true},
		{field:'StatusLastID',title:$g('��һ״̬ID'),width:100,hidden:true},
		{field:"RepStaus",title:$g('����״̬'),width:100,hidden:false},
		{field:'Medadrreceive',title:$g('����״̬'),width:100,hidden:true},
		{field:'Medadrreceivedr',title:$g('����״̬dr'),width:80,hidden:true},
		{field:'RepDate',title:$g("��������"),width:120,sortable:true},
		{field:'PatID',title:$g("�ǼǺ�"),width:120,hidden:true},
		{field:'AdmNo',title:$g("������"),width:120},
		{field:'PatName',title:$g('����'),width:120},
		{field:'RepType',title:$g('��������'),width:280},
		{field:'OccurDate',title:$g('��������'),width:120},
		{field:'OccurLoc',title:$g('��������'),width:150},
		{field:'LocDep',title:$g('����ϵͳ'),width:150,hidden:true},
		{field:'RepLoc',title:$g('�������'),width:150},	
		{field:'RepUser',title:$g('������'),width:120},
		{field:'RepTypeCode',title:$g('�������ʹ���'),width:120,hidden:true},
		{field:'RepImpFlag',title:$g('�ص��ע'),width:120,hidden:true},
		{field:'RepSubType',title:$g('����������'),width:120,hidden:true},
		{field:'RepLevel',title:$g('�����¼�����'),width:120,hidden:true},
		{field:'RepInjSev',title:$g('�˺����ض�'),width:120,hidden:true},
		{field:'RepTypeDr',title:$g('��������Dr'),width:120,hidden:true},
		{field:'RepOverTimeflag',title:$g('���ʱ'),width:120,hidden:true},
		{field:'AutOverTimeflag',title:$g('��ʿ����˳�ʱ'),width:120,hidden:true},
		{field:'FileFlag',title:$g('�鵵״̬'),width:80,hidden:true}
		
	]];

	//����datagrid
	$('#maindg').datagrid({
		toolbar: '#toolbar',//hxy add 08-28
		title:'', //hxy �����б�
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepList'+'&StrParam='+StrParam+'&LgParam='+LgParam+'&ParStr='+"",
		fit:true,
		rownumbers:true,
		columns:columns,
		remoteSort:false,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		height:300,
		nowrap:false,
		rowStyler:function(index,row){    // yangyongtao 2017-11-22
	        if ((row.RepStaus).indexOf("����") >= 0){  
	            return 'background-color:red;';  
	        }  
    	},
		onSortColumn:function (sort,order){
			ColSort=sort;
			ColOrder=order;
			Query();
 		},onDblClickRow:function(rowIndex, rowData){ 
        	setCellEditSymbol("DblClick", rowData, rowIndex);
		}
	});
	Query();
}
function GetParamList(){
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	var status="";  //״̬
	var typeevent=$('#typeevent').combobox('getValue');  //��������
	var statShare="";  //����״̬ 
	var receive="";  //$('#receive').combobox('getText');  //����״̬ 
	var OverTime="";  //����״̬
	if (status==undefined){status="";} 
	if (typeevent==undefined){typeevent="";}
	if (statShare==undefined){statShare="";}
	if (OverTime==undefined){OverTime="";}
	var PatNo=$.trim($("#patno").val());
	var Cancelflag="Y";
	//var StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+statShare+"^"+receive+"^^^"+"^"+OverTime+"^"+""+"^"+Cancelflag;
	StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+statShare+"^"+receive+"^^^^^^"+"^"+OverTime+"^^^^"+Cancelflag;;
	return StrParam; 
	}
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	StrParam=GetParamList();
	var ColParam=ColSort+"^"+ColOrder;
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepList',	
		queryParams:{
			StrParam:StrParam,
			LgParam:LgParam,
			ParStr:"",
			ColParam:ColParam}
	});
	querytitle="";
	$('#querytitle').html($g("�������ϲ�ѯ")+querytitle);	
	//var Rel='dhcadv.reportquery.csp?StrParam='+StrParam+'&querytitle='+"";
	//location.href=Rel;
}

function showDetail(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert($g("��ʾ"),$g("��ѡ���")+"!");
		return;
	}
	window.open("formrecorditm.csp?recordId="+rowsData.recordID)
}


///���ñ༭����
function setCellEditSymbol(value, rowData, rowIndex)
{
		var recordID=escape(rowData.recordID);         //����д��¼ID
		var RepID=escape(rowData.RepID);               //����ID   yangyongtao 2017-11-24
		var RepStaus=escape(rowData.RepStaus);         //��״̬
		if (RepStaus=="δ�ύ"){
			RepStaus=""; //����Ϊδ�ύ������Ϊ��
		}
		var RepTypeDr=escape(rowData.RepTypeDr);         //��������Dr
		var RepTypeCode=escape(rowData.RepTypeCode); //�������ʹ���
		var RepType=escape(rowData.RepType); //��������
		var StatusLast=escape(rowData.StatusLast); //������һ״̬
		var RepUser=escape(rowData.RepUser); //������
		var editFlag=-1;  //�޸ı�־  1�����޸� -1�������޸�   �����һ״̬Ϊ�ղ��ҽ���״̬�ǲ��أ�����״̬drΪ2��������޸�
		if((StatusLast!="")&&(RepStaus.indexOf("����") < 0)&&(RepUser!=LgUserName)){
			editFlag=-1;
		}
		var adrReceive=escape(rowData.Medadrreceivedr); //����״̬dr
		if(value!="DblClick"){  // 
			return "<a href='#' onclick=\"showEditWin('"+recordID+"','"+RepStaus+"','"+RepTypeDr+"','"+RepTypeCode+"','"+RepType+"','"+editFlag+"','"+RepID+"','"+adrReceive+"','"+RepUser+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_8.png' border=0/></a>";
		}else{
			showEditWin(recordID,RepStaus,RepTypeDr,RepTypeCode,RepType,editFlag,RepID,adrReceive,RepUser);
		}
}

//�༭����
function showEditWin(recordID,RepStaus,RepTypeDr,RepTypeCode,RepType,editFlag,RepID,adrReceive,RepUser)
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:$g('����༭'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		width:screen.availWidth-100,    ///2017-11-23  cy  �޸ĵ��������С 1250
		height:screen.availHeight-100
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&editFlag='+editFlag+'&RepID='+RepID+'&adrReceive='+adrReceive+'&RepUser='+RepUser+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
	//window.open("formrecorditmedit.csp?recordId="+rowsData.ID)
}

//��ӡ
function Print(){
	var rowsData = $("#maindg").datagrid('getSelections')
	if (rowsData.length=="0") {
		$.messager.alert($g("��ʾ"),$g("��ѡ��һ����¼")+"!");
		return;	
	}
	
	for(i=0;i<rowsData.length;i++){
		var recordId = rowsData[i].recordID;
		var RepID = rowsData[i].RepID;
		var RepTypeCode= rowsData[i].RepTypeCode;
		printRepForm(RepID,RepTypeCode);
		
	}	
	//window.open("formprint.csp?recordId="+rowsData[0].recordID);
}

//html��ӡ 
function htmlPrint(){

	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ")+":",$g("��ѡ����")+","+$g("����")+"��");
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("��ʾ")+":",$g("��ѡ��һ������")+"��");
		return;
	}
	var RepID=selItems[0].RepID;//����ID
	var RepTypeCode=selItems[0].RepTypeCode;//�������ʹ���/������Code
	var recordID=selItems[0].recordID;//����¼IDrecordID
	var url="dhcadv.htmlprint.csp?RepID="+RepID+"&RepTypeCode="+RepTypeCode+"&recordID="+recordID+"&prtOrExp="+this.id
	//return;
	window.open(url,"_blank");
}

//congyue 2017-09-06 �����ҳͼ�꣬������ҳ
function Gologin(){
	location.href='dhcadv.homepage.csp';
}
//2016-10-10
function CloseWinUpdate(){
	$('#win').window('close');
}
function cleanInput(){
	
	var StDate=formatDate(-7);  //һ��ǰ������
	var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
	$("#stdate").datebox("setValue", StDate);  //Init��ʼ����
	$("#enddate").datebox("setValue", EndDate);  //Init��������
	$('#dept').combobox('setValue',"");     //����ID
	$("#status").combobox('setValue',"");
	$('#typeevent').combobox('setValue',"");;  //��������
	$('#receive').combobox('setValue',"");;  //����״̬
	$('#Share').combobox('setValue',"");;  //����״̬
 	$("#ImpFlag").val("");             //��ע״̬
	$("#patno").val("");
}

// ����(��̬)
function Export()
{
	var typeevent=$('#typeevent').combobox('getValue');  //��������
	if((typeevent=="")||(typeevent=="ȫ��")){
		$.messager.alert($g("��ʾ")+":",$g("��ѡ����屨������")+"��","error");
		return;
	}
	/// 2021-07-09 cy ������ϸ����
	var LinkID="",FormNameID="";
	runClassMethod("web.DHCADVCOMMONPART","GetFormNameID",{"AdrEvtDr":typeevent},
	function(ret){
		FormNameID=ret
	},'text',false);
	runClassMethod("web.DHCADVEXPFIELD","GetExpLinkID",{"FormNameDr":FormNameID,"HospDr":LgHospID},
	function(ret){
		LinkID=ret
	},'text',false);
	//���崦�ڴ�״̬,�˳�
	if(!$('#ExportWin').is(":visible")){
		$('#ExportWin').window('open');
		reloadAllItmTable(LinkID);
		$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
		return;
	} 
	$('#ExportWin').window({
		title:$g('����'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:false,
		width:800,
		height:480
	});
	$('#ExportWin').window('open');
	initDatagrid(LinkID);
	$("#cuidAdd").bind('click',addItm); //$("a:contains('���Ԫ��')").
    $("#cuidDel").bind('click',delItm); //$("a:contains('ɾ��Ԫ��')")
    $("#cuidSelAll").bind('click',selAllItm); //$("a:contains('ȫ��ѡ��')")
    $("#cuidCanSel").bind('click',unSelAllItm); //$("a:contains('ȡ��ѡ��')")
    $("#cuidDelAll").bind('click',delAllItm); //$("a:contains('ȫ��ɾ��')")

}

function initDatagrid(LinkID){
	var columns=[[
		{field:'FormDicID',title:'FormDicID',width:50,hidden:true},
		{field:'DicField',title:'DicField',width:100,hidden:true},
		{field:'DicDesc',title:$g('ȫ����'),width:200}
	]];
	
	$("#allItmTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetSetFiel",
		queryParams:{
			LinkID:LinkID
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: $g('���ڼ�����Ϣ...'),
		rownumbers : false,
		pagination:false
	});	
	
	var setcolumns=[[
		{field:'FormDicID',title:'FormDicID',width:50,hidden:true},
		{field:'DicField',title:'DicField',width:100,hidden:true},
		{field:'DicDesc',title:$g('������'),width:200}
	]];

	$("#setItmTable").datagrid({
		url:"",
		fit:true,
		rownumbers:true,
		columns:setcolumns,
		loadMsg: $g('���ڼ�����Ϣ...'),
		rownumbers : false,
		pagination:false
	});
	$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
}
///���Ԫ��
function addItm(){
	var datas = $("#allItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert($g("��ʾ"),$g("δѡ���������")+"��");
		return;	    
	}
	for(var i=0;i<datas.length;i++)
	{
		$('#setItmTable').datagrid('insertRow',{
			index:0,
			row:{
				FormDicID:datas[i].FormDicID,
				DicField:datas[i].DicField,
				DicDesc:datas[i].DicDesc
			}
		
		})
		var aindex=$('#allItmTable').datagrid('getRowIndex',datas[i]);
		$('#allItmTable').datagrid('deleteRow',aindex);

	} 

}
function delItm(){
	var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert($g("��ʾ"),$g("δѡ���Ҳ�����")+"��");
		return;	    
	}
	for(var i=0;i<datas.length;i++)
	{
		var aindex=$('#setItmTable').datagrid('getRowIndex',datas[i]);
		$('#setItmTable').datagrid('deleteRow',aindex);
		$('#allItmTable').datagrid('insertRow',{
			index:0,
			row:{
				FormDicID:datas[i].FormDicID,
				DicField:datas[i].DicField,
				DicDesc:datas[i].DicDesc
			}
		})
	}
}

function delAllItm(){
	$("#setItmTable").datagrid("checkAll");
	delItm();
}
function selAllItm(){
	$("#allItmTable").datagrid("checkAll");
}
function unSelAllItm(){
	$("#allItmTable").datagrid("uncheckAll");
}
//reload ���ϱ�
function reloadAllItmTable(value){
	$("#allItmTable").datagrid('load',{
		LinkID:value
	})
}
function ExportOK(){
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var RepType=$('#typeevent').combobox('getText');  //��������
	var datas = $("#setItmTable").datagrid("getRows");
	if(datas.length<1){
		$.messager.alert($g("��ʾ"),$g("������Ϊ��")+"��"+$g("����ӵ�����")+"��");
		return;	    
	}
	var fieldList = [],descList=[],tablefield=[],tabledesc=[];
	for(var i=0;i<datas.length;i++)
	{
		if (datas[i].DicField.indexOf("UlcerPart")>=0){
			tablefield.push(datas[i].DicField);
			tabledesc.push(datas[i].DicDesc);
		}else{
			fieldList.push(datas[i].DicField);
			descList.push(datas[i].DicDesc);
		}
	} 
	var TitleList=fieldList.join("#");
	var DescList=descList.join("#");
	var TabFieldList=tablefield.join("#");
	var TabDescList=tabledesc.join("#");
	var filePath=""		//browseFolder();
	ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList,StrParam,LgParam);
	//if (typeof filePath=="undefined"){
	//	$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ��·����,���ԣ�</font>","error");
	//	return;
	//}
  	//var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	//if ((filePath.match(re)=="")||(filePath.match(re)==null)){
	//	$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
	//	return;
	//}
	//var Allflag=ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList);
	//if(Allflag==true){
	//	$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
	//	$('#ExportWin').window('close');
	//}else{
	//	$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>����ʧ�ܣ�</font>","info");
	//} 
	
}
// ȫ������Excel 
function ExportAll()
{
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var typeevent=$('#typeevent').combobox('getText');  //��������
	
	ExportAllData(StDate,EndDate,typeevent,StrParam,LgParam);
}
/////////////////////////////////////������ӡ�뵼��////////////////////////////////////////
///�����Ĵ�ӡ
function Print()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ")+":",$g("��ѡ����")+","+$g("����")+"��");
		return;
	}
	$.each(selItems, function(index, item){
		var RepID=item.RepID;//����ID
		var RepTypeCode=item.RepTypeCode;//�������ʹ���/������Code
		runClassMethod("web.DHCADVRepPrint","GetPrintData",{"AdvMasterDr":RepID,"PrintUserId":LgUserID,"LgHospID":LgHospID},function(ret){
			dhcprtPrint(RepTypeCode,ret,"print");
		},"json");
	})
}
///����word��ʽ
function ExportWordFile()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert($g("��ʾ:"),$g("��ѡ����,���ԣ�"));
		return;
	}
	if (selItems.length>1){
		$.messager.alert($g("��ʾ:"),$g("��ѡ��һ�����ݣ�"));
		return;
	}
	var RepID=selItems[0].RepID;//����ID
	var RepTypeCode=selItems[0].RepTypeCode;//�������ʹ���/������Code
	runClassMethod("web.DHCADVRepPrint","GetPrintData",{"AdvMasterDr":RepID,"PrintUserId":LgUserID,"LgHospID":LgHospID},function(ret){
		exportword(RepTypeCode,ret);
	},"json");
}
