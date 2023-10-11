/**
* FillName: divincdiscnfm.js
* Description: ҽ�����ȷ��(���)
* Creator DingSH
* Date: 2021-06-11
*/
// ���峣��
var PUB_CNT = {
	HITYPE:'',                               //ҽ������
	SSN: {
		USERID: session['LOGON.USERID'],	//����ԱID
		WARDID: session['LOGON.CTLOCID'],	//����ID
		CTLOCID: session['LOGON.WARDID'],	//����ID
		HOSPID: session['LOGON.HOSPID']		//Ժ��ID
	},
	SYSDTFRMT:function(){
		var _sysDateFormat=$.m({
		ClassName: "websys.Conversions",
		MethodName: "DateFormat"
	     },false);
	     
	     return _sysDateFormat;
		}
};

//��ں���
$(function(){
	setPageLayout();    //����ҳ�沼��
	setElementEvent();	//����ҳ��Ԫ���¼�
});

//����ҳ�沼��
function setPageLayout(){
	
	//��ʼ������
	initDate();
	//$('#stdate').datebox('setValue',GetLastMDate().split(",")[0]);
    //$('#endate').datebox('setValue',GetLastMDate().split(",")[1]);
	
	//ҽ������
	initHiTypeCmb();
	
	//�����¼
	initBallistDg();
	
	//������ϸ�б�
	InitDivDetDg();
	
	//ҽ�������쳣��¼
	initCentererrDg();
	
	//HIS�쳣��¼
	initHiserrDg();
	
	$('#CnfmDlBd').hide();
	
	
}

//����ҳ��Ԫ���¼�
function setElementEvent()
{
	 //ͬ��HIS��������
    $("#btnSynHisDiv").click(function () {
        SynHisDiv();
    });
	//�����ȡ+�����������
	 $("#btnDivCreate").click(function () {
        DivCreate();
    });
     
     //������ݲ�ѯ
	 $("#btnDivSumQuery").click(function () {
		SetBtnIsDisabled();
        DivSumQuery();
    });
    //�����������(�����״̬)
    $("#btnDivCreateDel").click(function () {
        DivCreateDel();
    });
    
    //���ȷ��
    $("#btnDivConfirm").click(function () {
        DivConfirm();
    });
    
	//��ֻ���
    $("#btnDivConfirmCancel").click(function () {
        DivConfirmCancel();
    });
   
	//�����ϸȷ��״̬(�Ƿ����뱾�����)����
    $("#btnUpdtCnfm").click(function () {
        UpdtDivDetCnfm();
    });
    //���´���ر�
    $("#btnCnfmDlC").click(function () {
        $('#CnfmDlBd').window('close');
    });
    
     //���������ϸ
     $("#btnDivDetEpot").click(function () {
        btnDivDetEpot();
    });
    
}
//��ʼ��ҽ������
function initHiTypeCmb()
{
	$HUI.combobox('#hiType',{
		url:$URL,
		editable:false,
		valueField:'cCode',
    	textField:'cDesc',
    	panelHeight:100,
    	method:'GET',
    	onBeforeLoad:function(param)
    	{
	    	param.ClassName='web.INSUDicDataCom';
	    	param.QueryName='QueryDic';
	    	param.ResultSetType='array';
	    	param.Type='DLLType';
	    	param.Code='';
	    	param.HospDr=PUB_CNT.SSN.HOSPID;
	    },
	    loadFilter:function(data){
			for(var i in data){
				if(data[i].cDesc=='ȫ��'){
					data.splice(i,1)
				}
			}
			return data
		},
		onSelect:function(rec){
			PUB_CNT.HITYPE=rec.cCode;
		}
	});
}

//��ʼ�������˽��dg
function initBallistDg()
{
	 $HUI.datagrid('#ballist',{
		iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		singleSelect: true,
		pageSize:10,
		pageList:[10, 20, 30],
		//toolbar:'#dgTB',
		pagination:true,
		fitColumns:false,
		columns:[[
			
			{field:'clrOptins',title:'�������',width:80,hidden:true},
			{field:'xzlb',title:'��������',width:150,hidden:true},
			{field:'xzlbDesc',title:'��������',width:150,hidden:true},
			{field:'clrType',title:'�������',width:80,hidden:true},
			{field:'clrTypeDesc',title:'�������',width:80,hidden:true},
			{field:'clrWay',title:'���㷽ʽ',width:80,hidden:true},
			{field:'insuType',title:'ҽ������',width:100},
			{field:'medfeeSumAmt',title:'�ܽ��',width:100,align:'right'},
			{field:'fundPaySumAmt',title:'����֧���ܶ�',width:100,align:'right'},
			{field:'ybzfPayAmt',title:'�˻�֧���ܶ�',width:100,align:'right'},
			{field:'cashPayAmt',title:'�����Ը��ܶ�',width:100,align:'right'},
			{field:'fixMedinsSetlCnt',title:'ҽ�����˴�',width:100},
			{field:'trtMonth',title:'�����·�',width:100},
			{field:'stmtBegnDate',title:'���˿�ʼ����',width:100},
			{field:'stmtEndDate',title:'���˽�������',width:100},
			{field:'blFlag',title:'���˱�־',width:100,hidden:true},
			{field:'blFlagDesc',title:'���˱�־',width:100,width:100/*,
				styler: function(value,row,index){
				        var rtnStyle="";
					    switch (row.blFlagDesc)
					    { 
					      case "�����" :
	    		                rtnStyle= 'background-color:#10B2C8;color:white';
	    		                break;
	                       case "���ȷ��" :
	    	                     rtnStyle= 'background-color:#1044C8;color:white';
	    	                     break;
	    	              case "��ֻ��˻�����" :
	    	                     rtnStyle= 'background-color:#EE4F38;color:white';
	    	                     break;  
	    	               default :
	    		                 rtnStyle= '';
	    		                 break;
	                     }
							
					return rtnStyle
				}*/},
			{field:'blDate',title:'��������',width:100},
			{field:'blTime',title:'����ʱ��',width:120},
			{field:'blUser',title:'������',width:120},
			{field:'optDate',title:'��������',width:80},
			{field:'optTime',title:'����ʱ��',width:120},
			{field:'optUser',title:'������',width:80},
			{field:'stmtRslt',title:'���˽��',width:80},
			{field:'stmtRsltDscr',title:'���˽��˵��',width:100},
			{field:'hospId',title:'hospId',width:80,hidden:true},
			{field:'zStr01',title:'ҵ������',width:80},
			{field:'zStr02',title:'�˷ѱ�ʶ',width:80},
			{field:'Rowid',title:'DivSumDr',width:100}
		]],
		onLoadSuccess:function(data){
			var t=data.total||0;
			if (t>0){
			   $('#ballist').datagrid('selectRow', 0);
			}

		},
        onSelect:function(rowIndex, rowData) {
            DivDetQuery();
            DivUnusualQuery(rowData.Rowid);
            SetBtnIsDisabled(rowData.blFlagDesc);
        },
        onUnselect:function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
		onDblClickRow:function(rowIndex,rowData){
				
		}
	});

}





//���ð�ť�Ƿ����
function SetBtnIsDisabled(blFlagDesc)
{
	switch (blFlagDesc)
	    { 
	      case "�����" :
                enableById("btnDivCreate");         /*�����ȡ*/
                enableById("btnDivSumQuery");       /*��ֲ�ѯ*/
                enableById("btnDivConfirm");        /*���ȷ��*/
                enableById("btnSynHisDiv");         /*ͬ��HIS����*/
                enableById("btnDivCreateDel");      /*�������*/
                disableById("btnDivConfirmCancel");   /*��ֻ���*/
                break;
           case "���ȷ��" :
                enableById("btnDivCreate");         /*�����ȡ*/
                enableById("btnDivSumQuery");       /*��ֲ�ѯ*/
                disableById("btnDivConfirm");        /*���ȷ��*/
                enableById("btnSynHisDiv");         /*ͬ��HIS����*/
                disableById("btnDivCreateDel");      /*�������*/
                enableById("btnDivConfirmCancel");   /*��ֻ���*/
                break;
          case "��ֻ���" :
                enableById("btnDivCreate");         /*�����ȡ*/
                enableById("btnDivSumQuery");       /*��ֲ�ѯ*/
                disableById("btnDivConfirm");        /*���ȷ��*/
                enableById("btnSynHisDiv");         /*ͬ��HIS����*/
                disableById("btnDivCreateDel");      /*�������*/
                disableById("btnDivConfirmCancel");   /*��ֻ���*/
                 break;
          case "�������" :
                enableById("btnDivCreate");         /*�����ȡ*/
                enableById("btnDivSumQuery");       /*��ֲ�ѯ*/
                disableById("btnDivConfirm");        /*���ȷ��*/
                enableById("btnSynHisDiv");         /*ͬ��HIS����*/
                disableById("btnDivCreateDel");      /*�������*/
                disableById("btnDivConfirmCancel");   /*��ֻ���*/
                break;      
           default :
                enableById("btnDivCreate");         /*�����ȡ*/
                enableById("btnDivSumQuery");       /*��ֲ�ѯ*/
                disableById("btnDivConfirm");        /*���ȷ��*/
                enableById("btnSynHisDiv");         /*ͬ��HIS����*/
                disableById("btnDivCreateDel");      /*�������*/
                disableById("btnDivConfirmCancel");   /*��ֻ���*/
                 break;
         }
}





//��ʼ��ҽ������ϸ�˽���б�
function InitDivDetDg()
{
	 DivDetDg=$HUI.datagrid('#divdetdg',{
		//iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		queryParams:{qid:1},
		singleSelect: true,
		pageSize:10,
		pageList:[10, 15, 20, 30],
		data:[],
		//toolbar:'#dgTB',
		pagination:true,
		fitColumns:false,
		checkOnSelect:false,
        singleSelect: true,
         frozenColumns: [[
            {
                field: 'TOpt',
                width: 60,
                title: '����',
                formatter: function (value, row, index) {
	                var title="'���ȷ�����'"
	                var src="'../scripts_lib/hisui-0.1.0/dist/css/icons/paper_pen.png'"
	                var onclk= "initCnfmDlBdFrm('" + index + "')" ;
                    if (row.blFlag == "1"){
	                     title="''"
	                     src="'../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png'";
	                     onclk="''";
	                    }
                    return "<img class='myTooltip' style='width:80' title="+title + " onclick=" +onclk + " src=" + src +"style='border:0px;cursor:pointer'>";

                },
                align:'center'
            }

        ]],
		columns:[[
			
			{field:'Rowid',title:'Rowid',width:60,hidden:true},
			{field:'patNo',title:'�ǼǺ�',width:100},
			{field:'psnname',title:'����',width:80},
			{field:'setlid',title:'������ˮ��',width:180},
			{field:'mdtrtid',title:'������ˮ��',width:180},
			{field:'psnno',title:'���˱��',width:180,hidden:true},
			{field:'certno',title:'֤������',width:180},
			{field:'medfeesumamt',title:'�ܽ��',width:100,align:'right'},
			{field:'fundpaysumamt',title:'����֧�����',width:100,align:'right'},
			{field:'divDate',title:'��������',width:100},
			{field:'divTime',title:'����ʱ��',width:100},
			{field:'cnfmFlagDesc',title:'�Ƿ����',width:100/*,styler: function(value,row,index){
				        var rtnStyle="";
					    switch (row.cnfmFlag)
					    { 
					      case "1" :
	    		                rtnStyle= 'background-color:#4B991B;color:white';
	    		                break;
	    		           case "0" :
	    		                rtnStyle= 'background-color:#EE4F38;color:white';
	    		                break;    
	    	               default :
	    		                 rtnStyle= '';
	    		                 break;
	                     }	
					return rtnStyle
				}*/},
			{field:'memo',title:'��ע',width:150},
			{field:'acctpay',title:'�˻�֧�����',width:100,align:'right'},
			{field:'psncashpay',title:'�����Ը����',width:100,align:'right'},
			{field:'psncerttype',title:'֤������',width:80},
			{field:'XzlxDesc',title:'��������',width:150},
			{field:'ClrTypeDesc',title:'�������',width:100},
			{field:'clroptinsDesc',title:'�������',width:80},
			{field:'stmtRslt',title:'���˽��',width:80},
			{field:'refdSetlFlag',title:'�˷ѱ�־',width:100,hidden:true},
			{field:'blCenterDivDr',title:'CenterDivDr',width:100}
			
		]],
	    onLoadSuccess:function(data){
			
		}
	});
}	



//��ʼ�����ȷ�ϱ�ʶ����
function initCnfmDlBdFrm(rowIndex) {
    //$('#RdInsuTypeDesc').val($("#InsuType").combobox('getText'));
    //$('#RdInsuType').val($("#InsuType").combobox('getValue'));
    var SelRow = $('#divdetdg').datagrid("getRows")[rowIndex];
    //var SelRow = $('#divdetdg').datagrid('getSelected');
	if(!SelRow){
		$.messager.alert('��ʾ','��ѡ��һ����¼��','info');
		return;
	}
	setValueById('cDivDetDr',SelRow.Rowid);
    setValueById('cName',SelRow.psnname);
    setValueById('cRegNo',SelRow.patNo);
    setValueById('cBcbxf',SelRow.medfeesumamt);
    setValueById('CJjzfe',SelRow.fundpaysumamt);
    setValueById('cDivDate',SelRow.divDate);
    setValueById('cDivTime',SelRow.divTime);
    if (SelRow.cnfmFlag == "1")
    {
       $HUI.radio("#cIsCnfm1").setValue(true);
    }else
    { 
        $HUI.radio("#cIsCnfm0").setValue(true);
	    
	 }
   
    setValueById('cCnfmBz',SelRow.memo);
    
    setValueById('cCertno',SelRow.certno);
      
    $('#CnfmDlBd').show();
    $HUI.dialog("#CnfmDlBd", {
        title: "���ȷ��״̬���",
        height: 322,
        width: 532,
        iconCls: 'icon-w-batch-add',
        modal: true
    })

}

//��ʼ��ҽ�������쳣����
function initCentererrDg()
{
	 centerErrdg=$HUI.datagrid('#centererrdg',{
		iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		queryParams:{qid:1},
		singleSelect: true,
		toolbar: [],
		pageSize:10,
		pageList:[10, 15, 20, 30],
		data:[],
		pagination:true,
		fitColumns:false,
		columns:[[
			{field:'Rowid',title:'Rowid',width:60,hidden:true},
			{field:'blDivDetDr',title:'blDivDetDr',hidden:true},
			{field:'blHisDivDr',title:'blHisDivDr',hidden:true },
		    {field:'patNo',title:'�ǼǺ�',width:100},
		    {field:'patName',title:'����',width:100},
			{field:'InsuType',title:'InsuType',hidden:true},
			{field:'djlsh',title:'����ID',width:180},
			{field:'zylsh',title:'����ID',width:180},
			{field:'hndFlag',title:'����״̬',width:80/*,styler: function(value,row,index){
				        var rtnStyle="";
					    switch (row.hndFlag)
					    { 
					      case "�ѳ���" :
	    		                rtnStyle= 'background-color:#1044C8;';
	    		                break;
	    	               default :
	    		                 rtnStyle= '';
	    		                 break;
	                     }	
					return rtnStyle
				}*/},
			{field:'psnno',title:'���˱��',width:180},
			
			{field:'psnName',title:'��������',width:100,hidden:true},
			{field:'InsuTotAmt',title:'�ܽ��',width:100,align:'right'},
			{field:'InsuJjzfe',title:'����֧�����',width:100,align:'right'},
			{field:'divDate',title:'��������',width:100},
			{field:'divTime',title:'����ʱ��',width:100},
			{field:'InsuZhzfe',title:'�˻�֧�����',width:100,align:'right'},
			{field:'InsuGrzfe',title:'�����Ը����',width:100,align:'right'},
			{field:'refdSetlFlag',title:'�˷ѱ�־',width:100},
			{field:'msgid',title:'���ͷ�������ˮ��',width:180},
			{field:'memo',title:'��ע',width:200},
			{field:'hndFUser',title:'������',width:100},
			{field:'hndDate',title:'��������',width:100},
			{field:'hndTime',title:'����ʱ��',width:100},
			{field:'blCenterDivDr',title:'blCenterDivDr',width:100}
		]],
        onSelect:function(rowIndex, rowData) {
			//ConGridQuery(rowIndex, rowData);
            //if($('#cked')[0].checked){ConAct("insertRow")}
        },
        onUnselect:function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
	    onLoadSuccess:function(data){
			//$(this).datagrid('options').queryParams.qid="0";
		}
	});	
}

//��ʼ��HIS�쳣����
function initHiserrDg()
{
	 hisErrdg=$HUI.datagrid('#hiserrdg',{
		iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		queryParams:{qid:1},
		singleSelect: true,
		toolbar: [],
		pageSize:10,
		pageList:[10, 15, 20, 30],
		data:[],
		//toolbar:'#dgTB',
		pagination:true,
		fitColumns:false,
		columns:[[
			{field:'Rowid',title:'Rowid',width:60,hidden:true},
			{field:'blDivDetDr',title:'blDivDetDr',hidden:true},
			{field:'blHisDivDr',title:'blHisDivDr',hidden:true},
			{field:'blCenterDivDr',title:'blCenterDivDr',hidden:true},
			{field:'InsuType',title:'InsuType',hidden:true},
			{field:'patNo',title:'�ǼǺ�',width:100},
		    {field:'patName',title:'����',width:100},
			{field:'djlsh',title:'����ID',width:180},
			{field:'zylsh',title:'����ID',width:180},
			//{field:'psnName',title:'��������',width:100},
			{field:'psnno',title:'���˱��',width:180},
			{field:'InsuTotAmt',title:'�ܽ��',width:100,align:'right'},
			{field:'InsuJjzfe',title:'����֧�����',width:100,align:'right'},
			{field:'divDate',title:'��������',width:100},
			{field:'divTime',title:'����ʱ��',width:100},
			{field:'InsuZhzfe',title:'�˻�֧�����',width:100,align:'right'},
			{field:'InsuGrzfe',title:'�����Ը����',width:100,align:'right'},
			{field:'refdSetlFlag',title:'�˷ѱ�־',width:100},
			{field:'msgid',title:'���ͷ�������ˮ��',width:180},
			{field:'memo',title:'��ע',width:200},
			{field:'blHisDivDr',title:'blHisDivDr',width:100}
		]],
        onSelect:function(rowIndex, rowData) {
			//ConGridQuery(rowIndex, rowData);
            //if($('#cked')[0].checked){ConAct("insertRow")}
        },
        onUnselect:function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
	    onLoadSuccess:function(data){
			//$(this).datagrid('options').queryParams.qid="0";
		}
	});
}

//��ѯ��ֽ��
function DivSumQuery()
{
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx="";
	var ClrType="";
	var Options="";
	if(StDate==""||EndDate==""){
		$.messager.alert('ע��','�������ڲ���Ϊ�գ�','info');
		return;
	}
	if(hiType==""){
		$.messager.alert('ע��','ҽ�����Ͳ���Ϊ�գ�','info');
		return;
	}
	//BusiType As %String = "", SetlOptions As %String = "", HiType As %String = "", RefdSetlFlag As %String = ""
	$HUI.datagrid('#ballist',{
		url:$URL+"?ClassName="+'INSU.MI.DAO.DivSum'+"&QueryName="+'InsuDivSumQuery'+"&StDate="+StDate+"&EndDate="+EndDate+"&ClrType="+ClrType+"&Xzlb="+Xzlx+"&UserId="+PUB_CNT.SSN.USERID+"&HospDr="+PUB_CNT.SSN.HOSPID+"&BusiType=0"+"&HiType="+hiType +"&RefdSetlFlag=0"+"&SetlOptions="+Options    

	})
}
//��������������ϼ�¼
function DivCreateDel()
{
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ��һ������ּ�¼��','info');
		return;
	}
	var blFlag=selectedRow.blFlag;
	if (blFlag!="0"){
		$.messager.alert('��ʾ','�Ǵ������¼�����������ϣ�','info');
		return;
	}
	var RowId=selectedRow.Rowid;
	$m({
		ClassName: "INSU.MI.BL.DivIncdisCtl",
		MethodName: "StrikeDivSumById",
		RowId: RowId,
		UserId:PUB_CNT.SSN.USERID,
		HospDr:PUB_CNT.SSN.HOSPID

 
  
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('��ʾ',"����ʧ�ܣ�"+rtn,'info');
		}
		DivSumQuery();
	});
	
}

//��ѯ�쳣����
function DivUnusualQuery(DivSumDr)
{
	if(DivSumDr==""){
		return;
	}
	var urlStr=$URL+"?ClassName=INSU.MI.DAO.Unusual&QueryName=DivUnusualQuery&blDivSumDr="+DivSumDr+"&HospDr="+PUB_CNT.SSN.HOSPID+"&UserId="+PUB_CNT.SSN.USERID+"&blFlag=1";
	$HUI.datagrid('#centererrdg',{
		url:urlStr
	});
	
	var urlStr=$URL+"?ClassName=INSU.MI.DAO.Unusual&QueryName=DivUnusualQuery&blDivSumDr="+DivSumDr+"&HospDr="+PUB_CNT.SSN.HOSPID+"&UserId="+PUB_CNT.SSN.USERID+"&blFlag=0";
	$HUI.datagrid('#hiserrdg',{
		url:urlStr
	});
	
}

//��ѯ����ϸ�˽��
function DivDetQuery()
{
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ��һ����¼��','info');
		return;
	}
	var DivSumDr=selectedRow.Rowid;
	if(DivSumDr==""){
		return;
	}
	var urlStr=$URL+"?ClassName=INSU.MI.DAO.DivDet&QueryName=DivDetRsltQuery&blDivSumDr="+DivSumDr+"&HospDr="+PUB_CNT.SSN.HOSPID+"&UserId="+PUB_CNT.SSN.USERID+"&blFlag=";
	$HUI.datagrid('#divdetdg',{
		url:urlStr
	});
	
}




//ͬ��HISҽ����������
function SynHisDiv() 
{
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	$.messager.progress({
		title: "��ʾ",
		text: '����ͬ��HISҽ�������������Ժ�....'
	});

	// ��ȡ�������
	$m({
		ClassName: "INSU.MI.BL.DivIncdisCtl",
		MethodName: "SynHisDivInfo",
		StDate: StDate,
		EndDate: EndDate,
	    UserId: PUB_CNT.SSN.USERID,
		HospDr: PUB_CNT.SSN.HOSPID,
		HiType:PUB_CNT.HITYPE,
		HAdmType:'I'
	},function(rtn){
		$.messager.progress("close");
		if((rtn.split("^")[0])<0){
			$.messager.alert('��ʾ','ͬ��HISҽ���������ݷ�������rtn='+rtn,'info');
			return;	
		}
		DivSumQuery();
	});
}



//��������ȡ
function DivCreate() 
{
	SynHisDiv();
	$.messager.progress({
		title: "��ʾ",
		text: '������ȡ�������������Ժ�....'
	});
	var DivSumDr=""; //��ȡ���ݺͻ��ܱ�ָ���޹� DingSH 20210615
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx=""	//$('#xzlx').combobox('getValue');
	var ClrType=""	//$('#clrType').combobox('getValue');
	var Options=""	//$('#centerno').combobox('getValue');
	
	if (StDate==""||EndDate==""){
		$.messager.alert('��ʾ','��ѡ��ʼ���ڡ���������!','info');
		return;
	}
	ExpString="^^^"+StDate+"^"+EndDate+"^"+DivSumDr+"^^^^^^^";
	var Flag=InsuDivInfoQuery(0,PUB_CNT.SSN.USERID,PUB_CNT.HITYPE,ExpString);
	if(Flag<0){
		$.messager.progress("close");
		$.messager.alert('��ʾ','�����ϸ��ȡʧ��','info');
		//return;
	}
	$.messager.alert('��ʾ','�����ϸ��ȡ�ɹ�','info');
	//�������
	CrtDivIncdisCnfmData(function(rtn){
		$.messager.progress("close");
		if((rtn.split("^")[0])<0){
			$.messager.alert('��ʾ','���ɴ�������ݴ���rtn='+rtn,'info');
			return;	
		}
		DivSumQuery();
		});	
	
}
//�����������
/// callBack �ص�����
function CrtDivIncdisCnfmData(callBack)
{
	
    var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx=""	//$('#xzlx').combobox('getValue');
	var ClrType=""	//$('#clrType').combobox('getValue');
	var Options=""	//$('#centerno').combobox('getValue');
	
	 //���ɶ��������
	$m({
		ClassName: 'INSU.MI.BL.DivIncdisCtl',
		MethodName: "CrtDivIncdisCnfmData",
		StDate:StDate,
		EndDate:EndDate ,
		ClrType: '',
		UserId: PUB_CNT.SSN.USERID,
		HospDr: PUB_CNT.SSN.HOSPID,
		SetlOptions: '',
		HiType:PUB_CNT.HITYPE,
		RefdSetlFlag:'0'
	},function(rtn){
		callBack(rtn);
	});

}

//����ύ
function DivConfirm() 
{
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ��һ����¼��','info');
		return;
	}
	var blFlag=selectedRow.blFlag;
	if ((blFlag!="0")&&(blFlag!="�����")){
		$.messager.alert('��ʾ','�ü�¼�Ǵ����״̬���������ظ�ȷ�ϣ�','info');
		return;
	}
	var RowId=selectedRow.Rowid;
	
	
	ExpString="^^^^^^^^^^"+RowId+"^";
	var Rtn=InsuDivInfoConfirm(0,PUB_CNT.SSN.USERID,PUB_CNT.HITYPE,ExpString);
	if(Rtn<0){
			$.messager.alert('��ʾ','���ȷ��ʧ��','info');
	}else{
			$.messager.alert('��ʾ','���ȷ�ϳɹ�','info');
	}
	DivSumQuery();
}

//����ύ����
function DivConfirmCancel() 
{
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ��һ����¼��','info');
		return;
	}
	var blFlag=selectedRow.blFlag;
	if ((blFlag!="1")&&(blFlag!="���ȷ��")){
		$.messager.alert('��ʾ','�ü�¼��δ������ȷ�ϣ����ܻ��ˣ�','info');
		return;
	}
	var RowId=selectedRow.Rowid;
	var ExpString="^^^^^^^^^^"+RowId+"^";
	var Rtn=InsuDivInfoConfirmCancel(0,PUB_CNT.SSN.USERID,PUB_CNT.HITYPE,ExpString);
	if(Rtn<0){
			$.messager.alert('��ʾ','���ȷ�ϻ���ʧ��','info');
	}else{
			$.messager.alert('��ʾ','���ȷ�ϻ��˳ɹ�','info');
	}
	DivSumQuery();
}






//��ʼ������
function initDate(){
	var today=new Date();
	date=new Date(today.getTime()-24*60*60*1000);
	var s0=date.getFullYear()+"-"+(date.getMonth())+"-"+"01" //date.getDate();
	var s1=date.getFullYear()+"-"+(date.getMonth())+"-"+getSpanDays(date.getMonth()) //date.getDate();
	if (PUB_CNT.SYSDTFRMT()==4)
	{
	 var s0="01" +"/"+(date.getMonth()+"/"+date.getFullYear());
	 var s1=getSpanDays(date.getMonth())+"/"+(date.getMonth()+"/"+date.getFullYear()); //date.getDate()
	}
	
	$('#stdate').datebox({
		value: s0,
	    formatter: function(date){
			var year=date.getFullYear();
			var month=date.getMonth()+1;
			var day=date.getDate();
				return year+"-"+(month<10 ? ("0"+month) : month)+"-"+(day<10?("0"+day):day);
		},
		
		onSelect:function(date){
			var StDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
			var EdDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+(date.getDate()+getSpanDays(date.getMonth()+1)-1);
			if (PUB_CNT.SYSDTFRMT()==4)
	        {
		       StDate=date.getDate()+"/"+(date.getMonth()+1)+"/"+date.getFullYear();
	           EdDate=(date.getDate()+getSpanDays(date.getMonth()+1)-1)+"/"+(date.getMonth()+1)+"/"+date.getFullYear();
	        }
			$('#stdate').datebox('setValue',StDate);
			$('#endate').datebox('setValue',EdDate);
		}
	});
	
	$('#endate').datebox({
		value: s1,
		formatter: function(date){
			var year=date.getFullYear();
			var month=date.getMonth()+1;
			var day=date.getDate();
				return year+"-"+(month<10 ? ("0"+month) : month)+"-"+(day<10?("0"+day):day);
			
		}
	});
	
	function getSpanDays(month,year){
		var SpanDays=31;
		if ((month == 4)||(month == 6)||(month == 9)||(month == 11)){
			 SpanDays=30;
			}
		if (month == 2) {
			var tyear=year||(new Date()).getFullYear();
			SpanDays=28;
			if((tyear%4 ==0)&&(tyear%100 !=0)){
				 SpanDays=29;
				}
			}
			
			return SpanDays ;
		
		}

}



///�������ȷ�ϱ�ʶ
function UpdtDivDetCnfm(){
	
	var DivDetDr=getValueById('cDivDetDr');
	if (DivDetDr == ""){$.messager.alert('��ʾ','��ѡ��һ����ϸ','info');return;}
	var checkedRadioJObj = $("input[name='cIsCnfm']:checked");
	var CnfmFlag=checkedRadioJObj.val();
	
	var Memo=getValueById('cCnfmBz');
	if (Memo == ""){$.messager.alert('��ʾ','��ֱ�ע����Ϊ��','info');return;}
	var UserId=PUB_CNT.SSN.USERID;
	var HospId=PUB_CNT.SSN.HOSPID;
	var certno=getValueById('cCertno');
    if (certno == ""){$.messager.alert('��ʾ','֤������(���֤��)����Ϊ��','info');return;}
	var ExpStr=certno+"^";
	var rtn=tkMakeServerCall("INSU.MI.BL.DivIncdisCtl","UpdtDivDetCnfm",DivDetDr,CnfmFlag,Memo,UserId,HospId,ExpStr);
	if (rtn.split("^")[0]<0){
		
		$.messager.alert('��ʾ','����ʧ��'+rtn,'info');
		}else{
			
			$.messager.alert('��ʾ','���³ɹ�','info');
			$('#CnfmDlBd').window('close');
			//�������
	        CrtDivIncdisCnfmData(function(rtn){
		    if((rtn.split("^")[0])<0){
			 $.messager.alert('��ʾ','���ɴ�������ݴ���rtn='+rtn,'info');
			 return;	
		    }
		     DivSumQuery();
		    });	
			}
	}
	
	
	//���������ϸ
function btnDivDetEpot()
{
	
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ������˵ļ�¼��','info');
		return;
	}
	
	var DivSumDr=selectedRow.Rowid;
	
	DivDetEpot(DivSumDr);
}

//�쳣���ݵ���
function DivDetEpot(DivSumDr)
{
	
	var ExcelName="DivDetCnfm"+getExcelFileName()
	
	$.messager.progress({
			   title: "��ʾ",
			   msg: '���ڵ����������',
			   text: '������....'
		   });
		   
		   
    var blFlag="",Celltxt="'"
	var rtn = tkMakeServerCall("websys.Query","ToExcel",ExcelName,"INSU.MI.DAO.DivDet","DivDetRsltQuery",DivSumDr,PUB_CNT.SSN.HOSPID,PUB_CNT.SSN.USERID,blFlag,Celltxt);
	if (rtn) location.href = rtn ; 
	setTimeout('$.messager.progress("close");', 3 * 1000);
  

 }
 
 
 function getExcelFileName() {
		var date = new Date();
	    var year = date.getFullYear();
		var month = date.getMonth() + 1;
		var day = date.getDate();
		var hour = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
		var minute = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
		var second = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();
		var milliSeconds = date.getMilliseconds();
		var currentTime = year+''+month + '' + day + '' + hour + '' + minute + '' + second + '' + milliSeconds;
		return currentTime;
	}
