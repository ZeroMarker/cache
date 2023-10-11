/* 
 * FileName:	insuhilistquery.js
 * User:		Hanzh
 * Date:		2021-05-14
 * Function:	ҽ��Ŀ¼ͨ�ò�ѯ
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
    //�س��¼�
    $(".textbox").on('keyup',function(e){
		if (e.keyCode==13){
			QryInTarItems_Click();
		}
	});
});
//����
function Clear(){
	setValueById('Begndate',"");
	setValueById('Enddate',"");
	setValueById('HiListCode',"");
	setValueById('HilistName',"");
	setValueById('Wubi',"");
	setValueById('Pinyin',"");
	setValueById('ListType',"");
	setValueById('MedChrgitmType',"");
	setValueById('ChrgitmLv',"");
	setValueById('HilistUseType',"");
	setValueById('LmtCpndType',"");
	setValueById('LmtUsedFlag',"");
	setValueById('MedUseFlag',"");
	setValueById('MatnUsedFlag',"");
	setValueById('ValiFlag',"");
	setValueById('THisBatch',"");
    $('#hiinfolist').datagrid("loadData",{total:0,rows:[]});
}
//����Ŀ¼����
function initTitemType(){
	$("#titemType").combobox({
        valueField: 'Infno', textField: 'InfnoDesc', panelHeight: "auto",
        url:$URL+"?ClassName=INSU.MI.BL.InsuHiListQuery&QueryName=QryListTypeByInfno&ResultSetType=array",
        //data:[{id:'',text:""}], 
		onBeforeLoad: function(param){
			param.Infno = "13*";
		} ,
		onLoadSuccess: function (data) {
		if (data) {
   				$('#titemType').combobox('setValue',data[0].Infno);
			}
			//����HIS��������
			//inittHisBatchs();
		    //����Ŀ¼��ѯ�����б�
		    initInput();
			//���ر����
		    initcolumns();
		},
		 onSelect: function (rec) {
			//$('#hiinfolist').datagrid("loadData",{total:0,rows:[]});
			//inittHisBatchs();
			initInput();
			initcolumns();
			//QryInTarItems_Click();
			Clear();
����  }  
    });
	}

//����HIS��������
function inittHisBatchs() {
    $("#THisBatch").combobox({
        valueField: 'HisBatch', textField: 'HisBatch', panelHeight: "auto",
        //data:[{id:'',text:""}], 
		onShowPanel: function () {
			var url = $(this).combobox('options').url;
			if (!url){
				var url = $URL+"?ClassName=INSU.MI.BL.InsuHiListQuery&QueryName=QryHisBatchByInfno&ResultSetType=array";
				$(this).combobox('reload',url);
			}
		},
		onBeforeLoad: function(param){
			param.Infno = getValueById('titemType')//param.q;
			param.HospDr = HOSPID
			param.ExpStr = ""
		}
    });
    
}

//����Ŀ¼��ѯ�����б�
function initInput() {
	//ҽ���շ���Ŀ���
	var cbox = $HUI.combobox("#MedChrgitmType", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"01","Text":"��λ��"},{"ID":"02","Text":"����"},{"ID":"03","Text":"����"},{"ID":"04","Text":"�����"},{"ID":"05","Text":"���Ʒ�"},{"ID":"06","Text":"������"},{"ID":"07","Text":"�����"},{"ID":"08","Text":"�������Ϸ�"},
				{"ID":"09","Text":"��ҩ��"},{"ID":"10","Text":"��ҩ��Ƭ��"},{"ID":"11","Text":"�г�ҩ��"},{"ID":"12","Text":"һ�����Ʒ�"},{"ID":"13","Text":"�Һŷ�"},{"ID":"14","Text":"������"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
	 //�շ���Ŀ�ȼ�
	var cbox = $HUI.combobox("#ChrgitmLv", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"1","Text":"����"},{"ID":"2","Text":"����"},{"ID":"3","Text":"�Է�"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
	 //Ŀ¼���
	var cbox = $HUI.combobox("#ListType", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"101","Text":"��ҩ"},{"ID":"102","Text":"�г�ҩ"},{"ID":"103","Text":"��ҩ��Ƭ"},{"ID":"104","Text":"���Ƽ�"},
				{"ID":"105","Text":"����ҩ"},{"ID":"201","Text":"������Ŀ"},{"ID":"301","Text":"ҽ�ò���"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
	 //����ʹ�ñ�־
	var cbox = $HUI.combobox("#LmtUsedFlag", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"1","Text":"��"},{"ID":"0","Text":"��"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
	 //ҽ��ʹ�ñ�־
	var cbox = $HUI.combobox("#MedUseFlag", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"1","Text":"��"},{"ID":"0","Text":"��"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
	 //����ʹ�ñ�־
	var cbox = $HUI.combobox("#MatnUsedFlag", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"1","Text":"��������"},{"ID":"0","Text":"����������"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
	 
	 //�޸���ʹ������
	var cbox = $HUI.combobox("#LmtCpndType", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"1","Text":"������������"},{"ID":"2","Text":"�޸�������"},{"ID":"3","Text":"������������"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
	 
	  //��Ч��־
	var cbox = $HUI.combobox("#ValiFlag", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"1","Text":"��Ч"},{"ID":"0","Text":"��Ч"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
}

/**
*��ʼ��click�¼�
*/
function init_mtClick() {
    //��ѯ
    $("#btnSearch").click(QryInTarItems_Click);
    //�ӿ�Ŀ¼��ѯ
    $("#btnItfSearch").click(InsuHilistQuery_Click);
    
}
//Ŀ¼��ѯ
function InsuHilistQuery_Click() {
	var UserId=session['LOGON.GROUPID'];
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr="00A"+"^"+getValueById('titemType')+"^^^";
	var URIParams="";
	var pageopt = $('#hiinfolist').datagrid('getPager').data("pagination").options;        //����,datagridID��datagrid��ID
    var pageNumber = pageopt.pageNumber;    //��ǰ�ǵڼ�ҳ
    var pageSize= pageopt.pageSize; //ÿҳ��ʾ����������
    
	URIParams=AddURLParam(URIParams,"query_date",getValueById('querydate'));
	URIParams=AddURLParam(URIParams,"hilist_code",getValueById('hilistcode'));
	URIParams=AddURLParam(URIParams,"insu_admdvs",getValueById('insuadmdvs'));
	URIParams=AddURLParam(URIParams,"begndate",getValueById('begndate'));
	URIParams=AddURLParam(URIParams,"hilist_name",getValueById('hilistname'));
	URIParams=AddURLParam(URIParams,"wubi",getValueById('wubi'));
	URIParams=AddURLParam(URIParams,"pinyin",getValueById('pinyin'));
	URIParams=AddURLParam(URIParams,"med_chrgitm_type",getValueById('medchrgitmtype'));
	URIParams=AddURLParam(URIParams,"chrgitm_lv",getValueById('chrgitmlv'));
	URIParams=AddURLParam(URIParams,"lmt_used_flag",getValueById('lmtusedflag'));
	URIParams=AddURLParam(URIParams,"list_type",getValueById('listtype'));
	URIParams=AddURLParam(URIParams,"med_use_flag",getValueById('meduseflag'));
	URIParams=AddURLParam(URIParams,"matn_used_flag",getValueById('matnusedflag'));
	URIParams=AddURLParam(URIParams,"hilist_use_type",getValueById('hilistusetype'));
	URIParams=AddURLParam(URIParams,"lmt_cpnd_type",getValueById('lmtcpndtype'));
	URIParams=AddURLParam(URIParams,"vali_flag",getValueById('valiflag'));
	//URIParams=AddURLParam(URIParams,"updt_time",getValueById('updttime'));
	URIParams=AddURLParam(URIParams,"updt_time",getValueById('UpdataTime'));
	URIParams=AddURLParam(URIParams,"page_num",pageNumber); //2022-11-25 JINS
	URIParams=AddURLParam(URIParams,"page_size",pageSize);

	ExpStr=ExpStr+"^"+URIParams
	var rtn = InsuHilistQry(0,GV.USERID,ExpStr); //DHCINSUPort.js
	if(!rtn){return;}
	if(rtn.split("^")[0]!=0){
		$.messager.alert("��ʾ","��ѯʧ��!rtn="+rtn, 'error')
		return;
	}
}

//��ѯҽ��Ŀ¼
function QryInTarItems_Click() {
	$('#hiinfolist').datagrid("loadData",{total:0,rows:[]});
    ///          	StDate:��ʼ����
	/// 			EndDate:��������
	/// 			HospId:ҽԺId(CT_Hospital,����Ϊ��)
	/// 			HiListCode:ҽ��Ŀ¼����(�ؼ���)
	/// 			HilistName:ҽ��Ŀ¼����(�ؼ���)
	/// 			Wubi:���������
	/// 			Pinyin:ƴ��������
	/// 	 		ListType:Ŀ¼���
	///         	MedChrgitmType:ҽ���շ���Ŀ���
	///        		ChrgitmLv:�շ���Ŀ�ȼ�
	///         	HilistUseType:ҽ��Ŀ¼ʹ�����
	/// 			LmtCpndType:�޸���ʹ������
	/// 	 		LmtUsedFlag:����ʹ�ñ�־
	///         	MedUseFlag:ҽ��ʹ�ñ�־
	///         	MatnUsedFlag:����ʹ�ñ�־
	///         	ValiFlag:��Ч��־
	/// 	 		THisBatch:��������

	//�ӿ����ʹӽ���ѡ��

    var titemType=$('#titemType').combobox("getValue");
    if (titemType==""){
	    $.messager.alert("��ʾ", "��ѡ���ѯ����!", 'info');
        return;  
	  }
	var t = new Date();//��ȡ��ǰʱ��
	var year = t.getFullYear();//��ȡ��ǰʱ�����
	var month = t.getMonth()+1;//��ȡ��ǰʱ���·�
	var day = t.getDate();//��ȡ��ǰʱ����
	var hour = t.getHours();
	var minute = t.getMinutes();
	var second = t.getSeconds();
	var nowTime = year+"/"+month+"/"+day+" "+hour+((minute<10)?":0":":")+minute+((second<10)?":0":":")
	+second;
	var UpTime=getValueById
	setValueById('QryTime',nowTime); 

    var StartDate = getValueById('Begndate');
    var EndDate = getValueById('Enddate');
    var HOSPID = GV.HOSPID;
    if (HOSPID == "") { HOSPID = "2" }
    
    var HiListCode = getValueById('HiListCode');
    var HilistName = getValueById('HilistName');
    var Wubi = getValueById('Wubi');
    var Pinyin = getValueById('Pinyin');
    var ListType = getValueById('ListType');
    var MedChrgitmType = getValueById('MedChrgitmType');
    var ChrgitmLv = getValueById('ChrgitmLv');
    var HilistUseType = getValueById('HilistUseType');
    
    var LmtCpndType = getValueById('LmtCpndType');
    var LmtUsedFlag = getValueById('LmtUsedFlag');
    var MedUseFlag = getValueById('MedUseFlag');
    var MatnUsedFlag = getValueById('MatnUsedFlag');
    
    var ValiFlag = getValueById('ValiFlag');
    var THisBatch = getValueById('THisBatch');

    $('#hiinfolist').datagrid('options').url = $URL;
	$.m({
		ClassName: "INSU.MI.BL.HiInfoListQRY",
		MethodName: "GetQueryNameByInfno",
		type: "GET",
		Infno: titemType
	}, function (rtn) {
        if (typeof rtn != "string")
         {
	       return ;
	     }
	     var rtnAry = rtn.split("^")
         if  (rtnAry[0]==-1){
	           return;
	         }
		$('#hiinfolist').datagrid('reload', {
        	ClassName: rtnAry[0],
        	QueryName: rtnAry[1],
        	StDate: StartDate,
        	EndDate: EndDate,
        	HospId: HOSPID,
        	HiListCode: HiListCode,
        	HilistName: HilistName,
        	Wubi: Wubi,
        	Pinyin: Pinyin,
        	ListType: ListType,
        	MedChrgitmType: MedChrgitmType,
        	ChrgitmLv: ChrgitmLv,
        	HilistUseType:HilistUseType,
       		LmtCpndType: LmtCpndType,
        	LmtUsedFlag: LmtUsedFlag,
        	MedUseFlag: MedUseFlag,
        	MatnUsedFlag: MatnUsedFlag,
        	ValiFlag: ValiFlag
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
    var columnsStr=tkMakeServerCall("INSU.MI.BL.InsuHiListQuery", "GetInsuColumnsByInfno", titemType);
    if(columnsStr.split("^")[0]==-1){
	     $.messager.alert("��Ҫ��ʾ", columnsStr, 'error');
         return;  
	    }
    var columns=JSON.parse(columnsStr)
    initTable(columns);
}
 function initTable(columns) {
	 //��ʼ��datagrid
    $HUI.datagrid("#hiinfolist", {
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

        },
//        onRowContextMenu: function (e, index, row) {
//			e.preventDefault();   //��ֹ�����Ĭ�ϵ��Ҽ��˵�����
//			//����Ҽ��˵�
//			initRightMenu(e);
//			//�ж��ǲ�����ͬһ����¼���һ��������ˢ��֧����ʽ��Ѻ��
//			if (row.pbrowid != getGlobalValue("BillID")) {
//				GV.BillList.selectRow(index);
//			}
//		}
    });
	 
 }
/**
 * �Ҽ��˵�
 */
function initRightMenu(e) {
	try {
		if (CV.RightMenus.length > 0) {
			var target = "rightyKey";
			var $target = $("#" + target);
			if (!$target.length) {
				$target = $("<div id=\"" + target + "\"></div>").appendTo("body");
				$target.menu();
				$.each(CV.RightMenus, function (index, item) {
					$target.menu("appendItem", {
						id: item.id,
						text: item.text,
						iconCls: item.iconCls,
						onclick: eval("(" + item.handler + ")")
					});
				});
			}
			$target.menu("show", {
				left: e.pageX,
				top: e.pageY
			});
		} 
	}catch (e) {
		$.messager.popover({msg: "�����Ҽ��˵�ʧ�ܣ�" + e.message, type: "error"});
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
