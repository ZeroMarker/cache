
/// Creator:    bianshuai
/// CreateDate: 2015-01-29
/// Descript:   ��ѯ�ظ��б�

var url="dhcpha.clinical.action.csp";
if ("undefined"!==typeof(websys_getMWToken)){
	url += "?MWToken="+websys_getMWToken()
	}
var consStatusArr = [{"value":"","text":$g('ȫ��')}, {"value":"Y","text":$g('���')}, {"value":"N","text":$g('δ���')}];
$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));  	  //Init��������
	
	$("a:contains("+$g('��ѯ')+")").bind("click",queryConsultDetail);
	
	/**
	 * ��ѯ��¼״̬
	 */
	var consStatusCombobox = new ListCombobox("consStatus",'',consStatusArr,{panelHeight:"auto"});
	consStatusCombobox.init();
	
	/**
	 * ��ѯ����
	 */
	 $('#consDept').combobox({
		mode:'remote',		
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
		     $('#consDept').combobox('reload',url+'&action=SelAllLoc&hospId='+LgHospID);
			//$('#consDept').combobox('reload',url+'&action=GetAllLocNewVersion&hospId='+LgHospID+'  ')
			//$('#dept').combobox('reload',url+'&action=SelAllLoc&HospID='+HospID)
		}
	}); 
	//var conDeptCombobox = new ListCombobox("consDept",url+'&action=QueryConDept','',{});
	//conDeptCombobox.init();
	
	///�س��¼� wangxuejian   2016/09/19
	$('#drug').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var unitUrl = url+'&action=QueryArcItmDetail&Input='+$('#drug').val(); 
			//var unitUrl =  "&Input="+$('#drug').val();
			/// ����ҽ�����б���
			new ListComponentWin($('#drug'), "", "600px", "" , unitUrl, ArcColumns, setCurrEditRowCellVal).init();
		}
	})
	
	
	InitConsultList(); //��ʼ����ѯ��Ϣ�б�

})

// wangxuejian 2016-09-19
ArcColumns = [[
	    {field:'itmDesc',title:$g('ҽ��������'),width:220},
	    {field:'itmCode',title:$g('ҽ�������'),width:100},
	    {field:'itmPrice',title:$g('����'),width:100},
		{field:'itmID',title:'itmID',width:80}
	]];	

///��ѯ��ťҽ������Ӧ����
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		$('#drug').focus().select();  ///���ý��� ��ѡ������
		return;
	}
	$('#drug').val(rowObj.itmDesc);  /// ҽ����
}
//��ʼ�������б�
function InitConsultList()
{
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'consultID',title:'consultID',width:80,hidden:true},
		{field:'finiFlag',title:$g('��ɱ�־'),width:50,align:'center',formatter:SetCellUrl},
		{field:'consDate',title:$g('��ѯ����'),width:100},
		{field:'consTime',title:$g('��ѯʱ��'),width:90},
		{field:'quesType',title:$g('��������'),width:120},
		{field:'consIden',title:$g('��ѯ���'),width:100},
		{field:'consDept',title:$g('��ѯ����'),width:160},
		{field:'consName',title:$g('��ѯ��'),width:100},
		{field:'consTele',title:$g('��ϵ�绰'),width:100},
		{field:'consDesc',title:$g('��������'),width:500},
		{field:'ansCount',title:$g('�ظ�����'),width:100},
		{field:'LkDetial',title:$g('����'),width:100,align:'center',formatter:SetCellOpUrl}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:$g('��ѯ�����б�'),
                singleSelect : true
		};
	var conDetListComponent = new ListComponent('conDetList', columns, '', option);
	conDetListComponent.Init();
	
	initScroll("#conDetList");//��ʼ����ʾ���������
        $('#conDetList').datagrid('loadData', {total:0,rows:[]});
}

 /**
  * �½���ѯ����
  */
function newCreateConsultWin(consultID){
	
	var option = {
		minimizable : false,
		maximizable : true,
		collapsible:true
		};
	var newConWindowUX = new WindowUX($g('�б�'), 'newConWin', '930', '550', option);
	newConWindowUX.Init();
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.replyconsult.csp?consultID='+consultID+'&MWToken='+websys_getMWToken()+'"></iframe>';
	$('#newConWin').html(iframe);
}

 /**
  * ��ѯ��ѯ����
  */
function queryConsultDetail(){
	
	//1�����datagrid 
	$('#conDetList').datagrid('loadData', {total:0,rows:[]});
	
	//2����ѯ
	var startDate=$('#startDate').datebox('getValue');   //��ʼ����
	var endDate=$('#endDate').datebox('getValue');       //��ֹ����
	
	var consStatus=$('#consStatus').combobox('getValue');    //��������
	var consDept=$('#consDept').combobox('getValue');        //��ѯ����
	var params=startDate +"^"+ endDate +"^^^" + consStatus +"^"+ consDept+"^^"+LgHospID;
	
	$('#conDetList').datagrid({
		url:url + "&action=QueryPhConsult",	
		queryParams:{
			params:params}
	});
}

//����
function SetCellUrl(value, rowData, rowIndex)
{
	var html = "";
	if (value == "Y"){
		html = "<span style='margin:0px 5px;font-weight:bold;color:red;'>"+$g("���")+"</span>";		
	}else{
		html = "<span style='margin:0px 5px;font-weight:bold;color:green;'>No</span>";
		}
    return html;
}

//����
function SetCellOpUrl(value, rowData, rowIndex)
{
	var html = "";
	if (rowData.finiFlag == "Y"){
		html = "<a href='#' onclick='newCreateConsultWin("+rowData.consultID+")' style='margin:0px 5px;font-weight:bold;color:red;text-decoration:none;'>"+$g("�鿴�ظ��б�")+"</a>";
		
	}else{
		html = "<a href='#' onclick='newCreateConsultWin("+rowData.consultID+")'>"+$g("�鿴�ظ��б�")+"</a>";
		}
    return html;
}

