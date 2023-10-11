/*
 *	Creator		zhaozhiduan
 *  CreatDate	2022.09.07
 *	Description	����ҩ��--����ͳ��
 *	JS			scripts/pha/op/v4/stat.presc.js
 */
var COMPOMENTS ={};
var COM_PID = "" ;
$(function () {
	PHA_COM.SetPanel('#qcondPanel');
	COMPOMENTS = OP_COMPOMENTS;
	InitGridStatPresc();	//	�����б�
	InitDict();
	InitEvent();			//	��ť�¼�
	Clean();				//	������ʼ����ѯ����
})
function InitEvent(){
	PHA_EVENT.Bind('#btnFind', 			'click', function () {QueryStatPresc();});
	//��� toolbar
	PHA_EVENT.Bind('#btnPrint', 		'click', function () {Print();});
	PHA_EVENT.Bind('#btnClean', 		'click', function () {Clean();});
	PHA_EVENT.Bind('#btnExport', 		'click', function () {Export();});
}
function InitDict(){
	 // ��������
    PHA.ComboBox('prescType',{
	    editable:false, 
    	data:[
    		{RowId:"1",Description:$g("���ﴦ��")},
    		{RowId:"2",Description:$g("���ﴦ��")},
    		{RowId:"3",Description:$g("��촦��")}
    	]
    });
     // ������
    PHA.ComboBox('incCatId',{
	   blurValidValue:true,  
    	url: PHA_STORE.INCStkCat().url
    });
    PHA.TriggerBox('phcCatId', {
        handler: function (data) {
            PHA_UX.DHCPHCCat('phcCatId', {}, function (data) {
                $('#phcCatId').triggerbox('setValue', data.phcCatDescAll);
                $('#phcCatId').triggerbox('setValueId', data.phcCatId);
            });
        },
        width:396
    });
}
// ��ʼ����ѯ����
function InitDefVal(){
	$("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
	$("#endDate").datebox("setValue",'t') ;
	$("#stTime").timespinner("setValue","000000");
	$("#endTime").timespinner("setValue","235959");
	$("#prescType").combobox("setValue","1");

}
function InitGridStatPresc(){
	var normalCol = [[
		{field:'TPrescType',		title: ("�ѱ�"),			width:100,		align:'left'},
	    {field:'TPrescNum',			title: ("��������"),		width:100,		align:'right'},
	    {field:'TPrescTotal',		title: ("��������"),		width:100,		align:'right'},
	    {field:'TPrescBL',			title: ("��������(%)"),		width:80,		align:'right'},
	    {field:'TPrescMax',			title: ("��ߴ���"),		width:100,		align:'right',		hidden:true},
	    {field:'TPrescMin',			title: ("��ʹ���"),		width:100,		align:'right',		hidden:true},
	    {field:'TPrescMaxPmi',		title: ("��߷��ǼǺ�"),	width:100,		align:'center'},
	    {field:'TPrescMinPmi',		title: ("��ͷ��ǼǺ�"),	width:100,		align:'center'},
	    {field:'TPrescMaxMoney',	title: ("��߷����"),		width:80,		align:'right'},
	    {field:'TPrescMinMoney',	title: ("��ͷ����"),		width:80,		align:'right'},
	    {field:'TPrescMoney',		title: ("�ϼƽ��"),		width:100,		align:'right'},
	    {field:'TPrescPhNum',		title: ("Ʒ����"),			width:80,		align:'right'},
	    {field:'TCYFS',				title: ("��ҩ����"),		width:80,		align:'right',		hidden:true},
	    {field:'TJYFS',				title: ("���帶��"),		width:80,		align:'right',		hidden:true},
	    {field:'TJYCF',				title: ("���崦������"),	width:80,		align:'right',		hidden:true}
	]];
	COMPOMENTS.ComomGrid("gridStatPresc",{
		toolbar : '#gridStatPrescBar',
		columns: normalCol,
		showFooter: true,
		onLoadSuccess : function(data) {
			if(data.total>0){
				$('#gridStatPresc').datagrid("selectRow",0);
			}
		}
	})
}
function GetParams(){
	var retJson = PHA.DomData("#qCondition",{doType: 'query',retType: 'Json'});
	if(retJson[0] == undefined) {return false;}
	var pJson = {};
	pJson = retJson[0];
	pJson.locId = PHAOP_COM.LogonData.LocId;
	return pJson;
}
// ��ѯ��ҩ����
function QueryStatPresc(){
	var $grid =  $("#gridStatPresc");
	var pJson = GetParams();
	if(pJson==false){return;}
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.PreStat.Api' ,
        pMethodName:'StatLocPresc',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// ����
function Clean(){
	PHA.DomData("#qCondition",{doType: 'clear'});
	$('#gridStatPresc').datagrid('clear');
	InitDefVal();
}
function Export(){
	PHAOP_COM.ExportGrid("gridStatPresc");
}
// ��ӡ
function Print(){
	var $grid = $("#gridStatPresc");
	var rowNum = $grid.datagrid('getData').rows.length;
	if(rowNum == 0){
		PHAOP_COM._Alert("ҳ��û������,�޷���ӡ!");
		return;
	}
	var stDateTime=$("#stDate").datebox("getValue") + " " + $("#stTime").timespinner('getValue');
	var endDateTime=$("#endDate").datebox("getValue")+ " " + $("#endTime").timespinner('getValue');
	var dateTimeRange=stDateTime+" �� "+endDateTime;
	var hospDesc = PHAOP_COM.LogonData.HospDesc;
	var Para = {
		titlemain:hospDesc+"����ͳ��",
		titlesecond: "ҩ��:"+PHAOP_COM.LogonData.LocDesc+"     ͳ�Ʒ�Χ:" + dateTimeRange,
		lasttitle:"��ӡ��:"+PHAOP_COM.LogonData.UserName+"      ��ӡʱ��:" + PHAOP_COM.PrintDateTime()
	}
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'PHAOPPrescStat',
		data:{
			Para: Para,
			Grid: {type:'hisui', grid:'gridStatPresc'}
		},
		aptListFields: ["lasttitle"],
		listBorder: {style:4, startX:1, endX:195,space:1},
	})
	/* ��ӡ��־ */
    OP_PRINTCOM.PrintLog("page",{
			Para: Para
		},{},{
			remarks: "����ͳ��",
			pointer: App_MenuCsp || ""
		}
	)
}
window.onbeforeunload = function (){
}