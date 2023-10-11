/* 
 * FileName:	dhcinsu.InsuItemsDL.js
 * User:		ydc
 * Modify:      DingSH 20210430
 * Date:		2021-04-20
 * Function:	newҽ��Ŀ¼����
 * Description: 
*/
 var GV = {
	UPDATEDATAID : '',
	HOSPDR:session['LOGON.HOSPID'] ,
	USERID:session['LOGON.USERID'] ,
	HOSPID:session['LOGON.HOSPID']			//Ժ��ID
}
 $(function () { 
 	window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} 
    //click�¼�
    init_mtClick();
    //����Ŀ¼����
    initTitemType();
});
//����
function Clear(){
	setValueById('trtEDate',"");
	setValueById('trtSDate',"");
	setValueById('tVer',"");
	setValueById('tKeyWords',"");
	setValueById('tKeyType',"");
	setValueById('tHisBatch',"");
    //$('#insutrtdg').datagrid("loadData",{total:0,rows:[]});
    $('#insutrtdg').datagrid("load",{});
}
//����Ŀ¼����
function initTitemType(){
	$("#titemType").combobox({
        valueField: 'Infno', textField: 'InfnoDesc', panelHeight: "auto",
        url:$URL+"?ClassName=INSU.MI.BL.InsuItemsDL&QueryName=QryListTypeByInfno&ResultSetType=array",
        //data:[{id:'',text:""}], 
		onBeforeLoad: function(param){
			param.Infno = "13*";
		} ,
		onLoadSuccess: function (data) {
		    if (data) {
   				$('#titemType').combobox('setValue',data[0].Infno);
			}
			//����Ŀ¼��ѯ����
		    initKeyTypes();
		    //���ذ汾��
		    initVers();
			//����HIS��������
			inittHisBatchs();
			//���ر����
		    initcolumns()
		},
		 onSelect: function (rec) {
			//$('#insutrtdg').datagrid("loadData",{total:0,rows:[]});
			initKeyTypes();
			initVers();
			inittHisBatchs();
			initcolumns();
			//QryInTarItems_Click();
			Clear();
����  }  
    });
	}
//���ز�ѯ����
function initKeyTypes() {
	
    //(0:��HIS�������ڲ���,1:��HIS�������κŲ���,2:��Ŀ¼����(ģ����ѯ)����,ҩƷ��Ʒ������(ģ����ѯ)����)
    $("#tKeyType").combobox({
        valueField: 'id', textField: 'desc', panelHeight: "auto",
        //data:[{id:'',text:""}], 
		onShowPanel: function () {
			var url = $(this).combobox('options').url;
			if (!url){
				var url = $URL+"?ClassName=INSU.MI.BL.InsuItemsDL&QueryName=QryKeyTypeByInfno&ResultSetType=array";
				$(this).combobox('reload',url);
			}
		},
		onBeforeLoad: function(param){
			param.Infno = getValueById('titemType')//param.q;
		}
    });
    
}
//���ذ汾��
function initVers() {
    $("#tVer").combobox({
        valueField: 'Ver', textField: 'Ver', panelHeight: "auto",
        //data:[{id:'',text:""}], 
		onShowPanel: function () {
			var url = $(this).combobox('options').url;
			if (!url){
				var url = $URL+"?ClassName=INSU.MI.BL.InsuItemsDL&QueryName=QryVerByInfno&ResultSetType=array";
				$(this).combobox('reload',url);
			}
		},
		onBeforeLoad: function(param){
			param.Infno = getValueById('titemType')//param.q;
		}
    });
    
}
//����HIS��������
function inittHisBatchs() {
    $("#tHisBatch").combobox({
        valueField: 'HisBatch', textField: 'HisBatch', panelHeight: "auto",
        //data:[{id:'',text:""}], 
		onShowPanel: function () {
			var url = $(this).combobox('options').url;
			if (!url){
				var url = $URL+"?ClassName=INSU.MI.BL.InsuItemsDL&QueryName=QryHisBatchByInfno&ResultSetType=array";
				$(this).combobox('reload',url);
			}
		},
		onBeforeLoad: function(param){
			param.Infno = getValueById('titemType')//param.q;
		}
    });
    
}

/**
*��ʼ��click�¼�
*/
function init_mtClick() {
    //����
    $("#btnTrtDL").click(MtQry_Click);
    //��ѯ
    $("#btnSearch").click(QryInTarItems_Click);
    
}

//��ѯҽ��Ŀ¼
function QryInTarItems_Click() {
	$('#insutrtdg').datagrid("loadData",{total:0,rows:[]});
    ///	 QryType:��������(0:��HIS�������ڲ���,1:��HIS�������κŲ���,2:��Ŀ¼����(ģ����ѯ)����,ҩƷ��Ʒ������(ģ����ѯ)����)
    ///          StDate:��ʼ����
    ///          EndDate:��������
    ///          HospId:ҽԺId(CT_Hospital,����Ϊ��)
    ///          HiType:ҽ������(00A)
    ///          Code:Ŀ¼����(�ؼ���)
    ///          Desc:ҩƷ��Ʒ������(�ؼ���)
    ///          HisBatch:1:��HIS�������κŲ���
    ///          Ver:�汾��

	//�ӿ����ʹӽ���ѡ��
    var titemType=$('#titemType').combobox("getValue");
    if (titemType==""){
	    $.messager.alert("��ʾ", "��ѡ��Ŀ¼����!", 'info');
        return;  
	  }
	  
    var StartDate = getValueById('trtSDate');
    var EndDate = getValueById('trtEDate');
    var KeyType =getValueById('tKeyType')  //$('#tKeyType').combobox("getValue");
    //+20221208 HanZH
    if ((KeyType=="")&&((titemType=="1301")||(titemType=="1308"))){
        $.messager.alert("��ʾ", "��ѡ���ѯ����!", 'info');
        return;
    }
    var KeyWords = $('#tKeyWords').val();
    var HOSPID = GV.HOSPID;
    if (HOSPID == "") { HOSPID = "2" }
    var tCode = ""
    var tDesc = ""
    var tHisBatch = getValueById('tHisBatch');
    if (KeyType == "2") {
        tCode = KeyWords
    }
    if ((KeyType == "3")||((KeyType == "4"))) {
        tDesc = KeyWords
    }
    var tVer = getValueById('tVer');

    $('#insutrtdg').datagrid('options').url = $URL;
	$.m({
		ClassName: "INSU.MI.BL.InsuItemsDL",
		MethodName: "GetQueryNameByInfno",
		type: "GET",
		Infno: titemType,
		HospDr: HOSPID
	}, function (rtn) {
        if (typeof rtn != "string")
         {
	       return ;
	     }
	     var rtnAry = rtn.split("^")
         if  (rtnAry[0]==-1){
	           return;
	         }
		$('#insutrtdg').datagrid('reload', {
        ClassName: rtnAry[0],
        QueryName: rtnAry[1],
        QryType: KeyType,
        StDate: StartDate,
        EndDate: EndDate,
        HospId: HOSPID,
        HiType: "00A",
        Code: tCode,
        Desc: tDesc,
        HisBatch: tHisBatch,
        Ver: tVer
    });
	});	
}
function initcolumns(){
	//�ӿ����ʹӽ���ѡ��
    //var titemType=$('#titemType').combobox("getValue");
     var titemType=getValueById('titemType');
    if (titemType==""){
	    $.messager.alert("��ʾ", "��ѡ��Ŀ¼����!", 'info');
        return;  
	  }
	//��̨��ȡ����
	var columns = new Array();//����������
    var columnsStr=tkMakeServerCall("INSU.MI.BL.InsuItemsDL", "GetInsuColumnsByInfno", titemType);
    if(columnsStr.split("^")[0]==-1){
	     $.messager.alert("��Ҫ��ʾ", columnsStr, 'error');
         return;  
	    }
    var columns=JSON.parse(columnsStr)
    initTable(columns);
}
 function initTable(columns) {
	 //��ʼ��datagrid
    $HUI.datagrid("#insutrtdg", {
        fit: true,
        width: '100%',
        height: 800,
        border: false,
        singleSelect: true,
        rownumbers: true,
        data: [],
        columns:columns,
        columns: [
                    columns,//ͨ��js��̬���ɡ�
                ],
        pageSize: 20,
        pagination: true,
        onClickRow: function (rowIndex, rowData) {

            //alert("rowData="+rowData.TRowid)   
            //InLocRowid=rowData.TRowid;
            //QryInLocRec();

        },
        onDblClickRow: function (rowIndex, rowData) {
            //InTarItemsEditClick(rowIndex);
        },
        onUnselect: function (rowIndex, rowData) {
            //alert(rowIndex+"-"+rowData.itemid)
        },
        onLoadSuccess: function (data) {
            var index = 0;

        }
    });
	 
 }


/**
*Ŀ¼����
*/
function MtQry_Click() {

    var ExpStr = ""  //ҽ������^���״���^HIS�������κ����������^�Ƿ�ȫ������^HIS���κ�
    //�ӿ����ʹӽ���ѡ��
    var Infno=getValueById('titemType');
    if (Infno==""){
	    $.messager.alert("��ʾ", "��ѡ��Ŀ¼����!", 'info');
        return;  
	  }
	var HisBatchIndex=tkMakeServerCall("INSU.MI.BL.InsuItemsDL", "GetHisBatchIndexByInfno", Infno);
    //DLAllFlag
    var DLAllFlag="0"
    //if ($('#DLAllFlag').checkbox('options').checked){DLAllFlag="1"} //IE������
    if (getValueById('DLAllFlag')){ DLAllFlag="1" }                  //DingSH 20210924
    //HIS���κ�
    var HisBatch=getValueById('tHisBatch');
    if(HisBatch==""){HisBatch="0"}; 	
    ExpStr="00A"+"^^"+Infno+"^"+HisBatchIndex+"^"+DLAllFlag+"^"+HisBatch
    var rtn=InsuPLDownload("0",GV.USERID,ExpStr); 
    if (!rtn) { return; }
    if (rtn != "-1") {
        $.messager.alert("��ʾ", "Ŀ¼�������!", 'info');
        return;
    }
}



//-----------------------------------------------
/*
* ����ѯ��ΰ��ո�ʽƴ��
* DingSH 2021-01-11
* input: QryArgs,name,value
* output: name1=value1&name2=value2&...&namen=valuen
* --------------------end	
*/
function AddQryParam(QryArgs,name,value){
	return QryArgs+="&"+name+"="+value;
}
/*
 * ���ز�ѯ����
 * data:[{},{}]��ʽ
 */
function loadQryGrid(dgName,data){
	$('#'+dgName).datagrid({data:data,loadMsg:'���ݼ�����...',loadFilter: pagerFilter });
	/* 
	*���ַ�ʽҲ����
	var data={total:RowsData.length,rows:RowsData}
	$('#'+dgName).datagrid({loadFilter: pagerFilter }).datagrid("loadData",data); 
	*/
}
/*
 * �����ֵ����ͺ��ֵ����ȡ����
 */
function GetDicDescByCode(DicType,Code){
	var desc="";
	desc = tkMakeServerCall("web.INSUDicDataCom","GetDicByCodeAndInd",DicType,Code,4);
	return desc !="" ? desc:Code;
	
}
