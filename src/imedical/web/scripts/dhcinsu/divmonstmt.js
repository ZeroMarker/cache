/**
* FillName: dhcinsu/divmonstmt.js
* Description: ҽ������
* Creator DingSH
* Date: 2021-06-09
*/
// ���峣��
var PUB_CNT = {
	HITYPE:'',                               //ҽ������
	REFDSETLFLAG:'1',                        //�˷ѽ����־��Ϊ0ʱ�����˶������ݲ������˷����ݣ�Ϊ1����ֵ��null��ȱʡʱ�����˶������ݰ����˷����ݣ�
	BLMOD:'0',                               //����ģʽ  1:�ն���,�����¶���
	DLALLFLAG:'0',                           //�Ƿ���Դ����ļ�����ȫ����ϸ1/0
	SSN: {
		USERID: session['LOGON.USERID'],	 //����ԱID
		WARDID: session['LOGON.CTLOCID'],	 //����ID
		CTLOCID: session['LOGON.WARDID'],	 //����ID
		HOSPID: session['LOGON.HOSPID']		 //Ժ��ID
	},
	SYSDTFRMT:function(){
		var _sysDateFormat=$.m({
		ClassName: "websys.Conversions",
		MethodName: "DateFormat"
	     },false);
	     
	     return _sysDateFormat;
		},
		
	BlList:undefined
	
};
var LockFlag = "";
//��ں���
$(function(){
	checkLock();// �ж��Ƿ�ֻ�ܲ�ѯ����
	GetjsonQueryUrl()
	setPageLayout();    //����ҳ�沼��
	setElementEvent();	//����ҳ��Ԫ���¼�
	
});

 //����ҳ�沼��
function setPageLayout(){
	//��ʼ������
	initDate();
	//ҽ������
	initHiTypeCmb();
	//��ʼ���������� +20230301
	initBlModType();
	//��ʼ������״̬ +20230301
	initBlStatus();
	//���˽����¼
	initBallistDg();
	//��ϸ�б�
	InitDivDetDg();
	//ҽ�������쳣��¼
	initCentererrDg();
	//HIS�쳣��¼
	initHiserrDg();
}
//����ҳ��Ԫ���¼�
function setElementEvent()
{
	
	 //ͬ��HIS��������
    $("#btnSynHisDiv").click(function () {
	     try {
         disableById("btnSynHisDiv");    
         $HUI.linkbutton('#btnSynHisDiv',{stopAllEventOnDisabled:true});   
         SynHisDiv(); 
        } catch (error) {
        
        }finally{
         enableById("btnSynHisDiv");    
          $HUI.linkbutton('#btnSynHisDiv',{stopAllEventOnDisabled:false}); 
        }
           
    });
   
	 /*���ɶ�������*/
	 $("#btnDivSumCreate").click(function () {
		  try {
         disableById("btnDivSumCreate");    
         $HUI.linkbutton('#btnDivSumCreate',{stopAllEventOnDisabled:true});   
          DivSumCreate_Click();
        } catch (error) {
        
        }finally{
         enableById("btnDivSumCreate");    
          $HUI.linkbutton('#btnDivSumCreate',{stopAllEventOnDisabled:false}); 
        }
        
       
    });
    
      /*��ѯ*/
	 $("#btnDivSumQuery").click(function () {
        DivSumQuery_click();
    });
   
    /*���϶�������*/
    $("#btnDivSumCreateDel").click(function () {
        DivSumCreateDel_click();
    });
    
   /*������*/
    $("#btnDivSumConfirm").click(function () {
        DivSumConfirm_Click();
    });
    
    /*����ϸ��*/
    $("#btnDivDetConfirm").click(function () {
        DivDetConfirm_click();
    });
   
    /*��������*/
    $("#btnClrAppy").click(function () {
        btnClrAppy_click();
    });
    /*�������볷��*/
    $("#btnClrAppyCancel").click(function () {
        btnClrAppyCancel_click();
    });
   
	/*//�����ϸȷ��״̬(�Ƿ����뱾�����)����
    $("#btnUpdtCnfm").click(function () {
        UpdtDivDetCnfm();
    });
    //���´���ر�
    $("#btnCnfmDlC").click(function () {
        $('#CnfmDlBd').window('close');
    });*/
    
    
	/*����ҽ����ϸ--��Ҫ���չ涨��ʽ�ṩ����*/
	$('#btnImportDet').off().on("click",btnImportDet);
	
	/*����ҽ�������쳣*/
	$('#btnStrikeForInsu').off().on("click",function(){
		var oldCancel = $.messager.defaults.cancel;
			$.messager.defaults.ok = "��";
			$.messager.defaults.cancel = "��";
			$.messager.confirm("��Ҫ��ʾ", "��ȷ���Ƿ���ϳ���Ҫ��?", function (r) {
				if (r) {
					btnStrikeForInsu();
				} else {
					
				}
			});
			$.messager.defaults.ok = oldOk;
			$.messager.defaults.cancel = oldCancel;
		});
     /*����HIS�쳣*/
	$('#btnStrikeForHis').off().on("click",btnStrikeForHis);
	/*�������������ForHIS,�ʺϵ�������ҽ�����Ľ�������*/
	$('#btnImportThirdDet').off().on("click",btnImportThirdDet);
	/*���������쳣*/
	$('#btnCenterErrEpot').off().on("click",btnCenterErrEpot);
	/*����HIS�쳣*/
	$('#btnHisErrEpot').off().on("click",btnHisErrEpot);
  
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
			PUB_CNT.HITYPE = rec.cCode;
			//initSetlOptinsCmb();
			initInsutypeCmb();
			initClrTypeCmb();
			initInsuHospCmb();	// +20230301
		},
		 onLoadSuccess:function(){
			$('#hiType').combobox('select','00A');
		}
	});
}

//��ʼ���������
function initClrTypeCmb(){
 $HUI.combobox('#clrType',{   
	    url:$URL,
		editable:false,
		valueField:'cCode',
		textField:'cDesc',
		method:'GET',
		onBeforeLoad:function(param){
			param.ClassName='web.INSUDicDataCom';
			param.QueryName='QueryDic';
			param.ResultSetType='array';
			param.Type=('clr_type'+PUB_CNT.HITYPE);
			param.Code='';
			param.HospDr=PUB_CNT.SSN.HOSPID;	
		},
		value: ''
	}); 
}
//��ʼ�����㾭��ṹ
function initSetlOptinsCmb()
{
	$HUI.combobox('#setlOptins',{
		url:$URL,
		editable:false,
		valueField:'cCode',
		textField:'cDesc',
		method:'GET',
		onBeforeLoad:function(param){
			param.ClassName='web.INSUDicDataCom';
			param.QueryName='QueryDic';
			param.ResultSetType='array';
			param.Type=('setlOptins'+PUB_CNT.HITYPE);
			param.Code='';
			param.HospDr=PUB_CNT.SSN.HOSPID;	
		}
	});
}
//��ʼ����������
function initInsutypeCmb()
{
	$HUI.combobox('#insutype',{
		url:$URL,
		editable:false,
		valueField:'cCode',
		textField:'cDesc',
		method:'GET',
		onBeforeLoad:function(param){
			param.ClassName='web.INSUDicDataCom';
			param.QueryName='QueryDic';
			param.ResultSetType='array';
			param.Type=('insutype'+PUB_CNT.HITYPE);
			param.Code='';
			param.HospDr=PUB_CNT.SSN.HOSPID;
		},
		loadFilter:function(data){
			for(var i in data){
				//if(data[i].cDesc=='ȫ��'){
				//	data.splice(i,1)
				//}
			}
			
			return data
		}
	});
}

//��ʼ�������˽��dg
function initBallistDg()
{
	PUB_CNT.BlList=$HUI.datagrid('#ballist',{
		iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		//singleSelect: true,
		pageSize:100,
		pageList:[10, 30, 100],
		//toolbar:'#dgTB',
		pagination:true,
		fitColumns:false,
		frozenColumns:[[
		{title: 'ck', field: 'sck', checkbox: true},
		{field:'fundkey',title:'����Ψһ��',width:186},
		{field:'clrOptins',title:'�籣�������',width:80,hidden:true},
		{field:'clrType',title:'�������',width:80,hidden:true},
		{field:'clrTypeDesc',title:'�������',width:80},
		{field:'xzlb',title:'��������',width:150,hidden:true},
		{field:'xzlbDesc',title:'��������',width:150},
		{field:'clrWay',title:'���㷽ʽ',width:80,hidden:true},
		{field:'insuType',title:'ҽ������',width:80},
		{field:'medfeeSumAmt',title:'�ܽ��',width:100,align:'right'},
		{field:'fundPaySumAmt',title:'����֧���ܶ�',width:100,align:'right'},
		{field:'ybzfPayAmt',title:'�˻�֧���ܶ�',width:100,align:'right'},
		{field:'cashPayAmt',title:'�����Ը��ܶ�',width:100,align:'right'},
		{field:'fixMedinsSetlCnt',title:'ҽ�����˴�',width:100}
		]],
		columns:[[
			{field:'stmtBegnDate',title:'���˿�ʼ����',width:100},
			{field:'stmtEndDate',title:'���˽�������',width:100},
			{field:'blFlag',title:'���˱�־',width:100,hidden:true},
			{field:'blFlagDesc',title:'���˱�־',width:100},
			{field:'stmtRslt',title:'���˽��',width:80},
			{field:'stmtRsltDscr',title:'���˽��˵��',width:200},
			{field:'blDate',title:'��������',width:100},
			{field:'blTime',title:'����ʱ��',width:100},
			{field:'blUser',title:'������',width:100},
			{field:'setlOptins',title:'���㾭�����',width:100},
			{field:'clrAppyStas',title:'����״̬',width:80},
			{field:'clrAppyEvtId',title:'�����¼�ID',width:120},
			{field:'clrAppyUser',title:'������',width:100},
			{field:'clrAppyDate',title:'��������',width:100},
			{field:'clrAppyTime',title:'����ʱ��',width:100},
			{field:'optDate',title:'��������',width:100},
			{field:'optTime',title:'����ʱ��',width:100},
			{field:'optUser',title:'������',width:80},
			{field:'hospId',title:'hospId',width:80,hidden:true},
			{field:'blMod',title:'��������',width:80,hidden:true},
			{field:'trtMonth',title:'��������',width:80,hidden:true},
			{field:'zStr01',title:'��ע',width:80},
			{field:'zStr02',title:'��ע',width:100},
			{field:'Rowid',title:'DivSumDr',width:100}
		]],
        onSelect:function(rowIndex, rowData) {
	        //SetBtnIsDisabled(rowData.blFlagDesc);
            DivUnusualQuery(rowData.Rowid);
            DivDetQuery();
        },
        onClickCell: function (rowIndex, field, value) {
	       ShwBlRsDialog(field, value,rowIndex);
        },
        onUnselect:function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
		onLoadSuccess:function(data){
			
			//$(this).datagrid('options').queryParams.qid="0";
		},
		onCheck: function (rowIndex, rowData) {
		if ((rowData.blFlag == "1")||(rowData.blFlag == "3")) {
			    PUB_CNT.BlList.uncheckRow(rowIndex);
			}
		else{
				SetBtnIsDisabled("������");
			}
		},
		onCheckAll: function (rows) {
			var Flag=0;
			$.each(rows, function (index, row) {
				if (!row.Rowid) {
					return true;
				}
				if ((row.blFlag == "1")||(row.blFlag == "3")) {
					PUB_CNT.BlList.uncheckRow(index);
					 
				}else{Flag=1}
			});
			
			if (Flag==1){
				   SetBtnIsDisabled("������");
				}
			
		}
		
	});

}
//���ð�ť�Ƿ����
function SetBtnIsDisabled(blFlagDesc)
{
	switch (blFlagDesc)
	    { 
	      case "������" :
                enableById("btnDivSumConfirm");    /*������*/
                enableById("btnImportDet");       /*����ҽ����ϸ*/
                enableById("btnImportThirdDet");  /*�����������ϸ*/
                enableById("btnDivSumCreateDel"); /*���϶�������*/
                enableById("btnDivDetConfirm");   /*����ϸ��*/
                break;
           case "���˳ɹ�" :
                disableById("btnDivSumCreate");     /*���ɶ�������*/
                disableById("btnDivSumConfirm");    /*������*/
                disableById("btnImportDet");        /*����ҽ����ϸ*/
                disableById("btnImportThirdDet");   /*�����������ϸ*/
                //disableById("btnDivSumCreateDel");    /*���϶�������*/
                 enableById("btnDivSumCreateDel");    /*���϶�������*/
                disableById("btnDivDetConfirm");     /*����ϸ��*/
                break;
          case "����ʧ��" :
                enableById("btnDivSumCreate");      /*���ɶ�������*/
                enableById("btnDivSumConfirm");    /*������*/
                enableById("btnImportDet");        /*����ҽ����ϸ*/
                enableById("btnImportThirdDet");    /*�����������ϸ*/
                disableById("btnDivSumCreateDel");  /*���϶�������*/
                enableById("btnDivDetConfirm");    /*����ϸ��*/
                 break;
          case "��������" :
                enableById("btnDivSumCreate");      /*���ɶ�������*/
                disableById("btnDivSumConfirm");    /*������*/
                disableById("btnImportDet");        /*����ҽ����ϸ*/
                disableById("btnImportThirdDet");   /*�����������ϸ*/
                disableById("btnDivSumCreateDel");  /*���϶�������*/
                disableById("btnDivDetConfirm");     /*����ϸ��*/
                break;      
           default :
                enableById("btnDivSumCreate");      /*���ɶ�������*/
                disableById("btnDivSumConfirm");    /*������*/
                enableById("btnImportDet");         /*����ҽ����ϸ*/
                enableById("btnImportThirdDet");    /*�����������ϸ*/
                disableById("btnDivSumCreateDel");  /*���϶�������*/
                disableById("btnDivDetConfirm");    /*����ϸ��*/
                 break;
         }
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
		pageSize:10,
		pageList:[10, 15, 20, 30],
		data:[],
		toolbar:[],
		pagination:true,
		fitColumns:false,
		//Rowid,blDivDetDr,blHisDivDr,blCenterDivDr,InsuType,psnno,InsuTotAmt,InsuJjzfe,InsuZhzfe,InsuGrzfe,djlsh,zylsh,msgid,refdSetlFlag,memo
		columns:[[
			{field:'Rowid',title:'Rowid',width:60,hidden:true},
			{field:'blDivDetDr',title:'blDivDetDr',hidden:true},
			{field:'blHisDivDr',title:'blHisDivDr',hidden:true },
		    {field:'patNo',title:'�ǼǺ�',width:100},
		    {field:'patName',title:'����',width:100},
			{field:'InsuType',title:'InsuType',hidden:true},
			{field:'djlsh',title:'����ID',width:100},
			{field:'zylsh',title:'����ID',width:100},
			{field:'hndFlag',title:'����״̬',width:80,styler: function(value,row,index){
				        var rtnStyle="";
					    switch (row.hndFlag)
					    { 
					      case "�ѳ���" :
	    		                rtnStyle= 'background-color:#F58800;color:white';
	    		                break;
	    	               default :
	    		                 rtnStyle= '';
	    		                 break;
	                     }	
					return rtnStyle
				}},
			{field:'psnno',title:'���˱��',width:180},
			{field:'msgid',title:'���ͷ�������ˮ��',width:180},
			{field:'psnName',title:'��������',width:100,hidden:true},
			{field:'InsuTotAmt',title:'�ܽ��',width:100,align:'right'},
			{field:'InsuJjzfe',title:'����֧�����',width:100,align:'right'},
			{field:'divDate',title:'��������',width:100},
			{field:'divTime',title:'����ʱ��',width:100},
			{field:'InsuZhzfe',title:'�˻�֧�����',width:100,align:'right'},
			{field:'InsuGrzfe',title:'�����Ը����',width:100,align:'right'},
			{field:'refdSetlFlag',title:'�˷ѱ�־',width:100},
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
		pageSize:10,
		pageList:[10, 15, 20, 30],
		data:[],
		toolbar:[],
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
			{field:'djlsh',title:'����ID',width:100},
			{field:'zylsh',title:'����ID',width:100},
			//{field:'psnName',title:'��������',width:100},
			{field:'psnno',title:'���˱��',width:180},
			{field:'msgid',title:'���ͷ�������ˮ��',width:180},
			{field:'InsuTotAmt',title:'�ܽ��',width:100,align:'right'},
			{field:'InsuJjzfe',title:'����֧�����',width:100,align:'right'},
			{field:'divDate',title:'��������',width:100},
			{field:'divTime',title:'����ʱ��',width:100},
			{field:'InsuZhzfe',title:'�˻�֧�����',width:100,align:'right'},
			{field:'InsuGrzfe',title:'�����Ը����',width:100,align:'right'},
			{field:'refdSetlFlag',title:'�˷ѱ�־',width:100},
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

//��ʼ��ҽ������ϸ�˽���б�
function InitDivDetDg()
{
	 DivDetDg=$HUI.datagrid('#divdetdg',{
		iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		queryParams:{qid:1},
		singleSelect: true,
		pageSize:10,
		pageList:[10, 15, 20, 30,9999],
		data:[],
		toolbar:[],
		pagination:true,
		fitColumns:false,
		checkOnSelect:false,
        singleSelect: true,
        remoteSort: false,
		columns:[[
			{field:'Rowid',title:'Rowid',width:60,hidden:true},
			{field:'patNo',title:'�ǼǺ�',width:100},
			{field:'psnname',title:'����',width:80},
			{field:'cmprRslt',title:'�Ƿ��ƽ', width:100,align:'center',
			formatter: function(value,row,index){
				if (row.blCenterDivDr>0){
					return "��";
				} else {
					return "��";
				 }
			   },
			   /* sorter:function(a,b){  
			
					if (a == b){  
						return 1;  
					} else {  
						return -1;  
					}  
				
			  }*/  
			},
			{field:'setlid',title:'������ˮ��',width:180},
			{field:'mdtrtid',title:'������ˮ��',width:180},
			{field:'psnno',title:'���˱��',width:180},
			{field:'medfeesumamt',title:'�ܽ��',width:100,align:'right'},
			{field:'fundpaysumamt',title:'����֧�����',width:100,align:'right'},
			{field:'acctpay',title:'�˻�֧�����',width:100,align:'right'},
			{field:'psncashpay',title:'�����Ը����',width:100,align:'right'},
			{field:'divDate',title:'��������',width:100},
			{field:'divTime',title:'����ʱ��',width:100},
			{field:'blFlag',title:'����״̬',width:100,styler: function(value,row,index){
				        var rtnStyle="";
					    switch (row.blFlag)
					    { 
					      case "0" :
	    		                rtnStyle= 'background-color:#10B2C8;color:white';
	    		                break;
	                       case "1" :
	    	                     rtnStyle= 'background-color:#1044C8;color:white';
	    	                     break;
	    	              case "2" :
	    	                     rtnStyle= 'background-color:#EE4F38;color:white';
	    	                     break;
	    	               default :
	    		                 rtnStyle= '';
	    		                 break;
	                     }	
					return rtnStyle
				}},
			{field:'msgid',title:'���ͷ�����ID',width:255},
			{field:'stmtRslt',title:'���˽��',width:80},
			{field:'refdSetlFlag',title:'�˷ѽ����־',width:120},
			{field:'memo',title:'��ע',width:150},
			{field:'psncerttype',title:'֤������',width:80},
			{field:'certno',title:'֤������',width:180},
			{field:'XzlxDesc',title:'��������',width:150},
			{field:'ClrTypeDesc',title:'�������',width:100},
			{field:'clroptinsDesc',title:'�������',width:80},
			{field:'blCenterDivDr',title:'CenterDivDr',width:100}
			
		]],
	    onLoadSuccess:function(data){
			
		}
	});
}	
//���ɶ��˼�¼
function DivSumCreate_Click()
{
	
	 var StDate=$('#stdate').datebox('getValue');
	 var EndDate=$('#endate').datebox('getValue');
	 var hiType=$('#hiType').combobox('getValue');
	 var insutype=$('#insutype').combobox('getValue');
	 var ClrType=$('#clrType').combobox('getValue');
	 //var setlOptions=$('#setlOptins').combobox('getValue');
	 var setlOptions=""
	 var blModType=$('#blModType').combobox('getValue');
	 var InsuHospCode=$('#InsuHospCode').combobox('getValue');
	 var blStatus=$('#blStatus').combobox('getValue');
	 
	 if(hiType == ""){
		$.messager.alert('��ʾ','��ѡ��ҽ�����','info');
	    return;	
	 }
	 //SynHisDiv();  
	 $.messager.progress({
	 	title: "��ʾ",
	 	text: '�������ɶ����������Ժ�....'
	 });
	 // BlMod As %String = "", InFundkey As %String = "", ExpStr As %String = ""
	 $m({
	 	ClassName: "INSU.MI.BL.DivMonstmtCtl",
	 	MethodName: "CrtDivMonstmtDataStd",
	 	StDate: StDate,
	 	EndDate: EndDate,
	 	ClrType: ClrType,
	 	Xzlb: insutype,
	 	UserId: PUB_CNT.SSN.USERID,
	 	HospDr: PUB_CNT.SSN.HOSPID,
	 	setlOptions:setlOptions,
 	    HiType:hiType,
	 	RefdSetlFlag:PUB_CNT.REFDSETLFLAG,   //�Ƿ�����˷����ݣ�0:������
	 	BlMod:blModType,                     //�������ͣ�0:�¶���,1:�ն��� PUB_CNT.BLMOD
	 	ExpStr:InsuHospCode+"^"              //��չ����ҽ�����Ķ�ҽԺ����^
	 },function(rtn){
	 	if(((rtn).split("^"))[0]<0){
	 	    $.messager.alert('��ʾ','���ɶ������ݷ�������rtn='+rtn,'info');
	 		$.messager.progress("close");
	 		return;	
	 	}else{
	 		 $.messager.progress("close");
	 		}
	 	//�������ɳɹ�,��ȡ�����������ݣ��ύ����
	 	//$.messager.alert('��ʾ','���ɶ������ݳɹ�!');
	 	$.messager.popover({
	 			msg: '���ɶ������ݳɹ�!',
	 			type: 'success',
	 			timeout: 2000, 		//0���Զ��رա�3000s
	 			showType: 'slide'  
	 		});
	 	DivSumQuery_click();
	 });    
}

//������ 
function DivSumConfirm_Click()
{
  try
    {
	    var rows= PUB_CNT.BlList.getChecked();
	    if(rows.length<=0){
		      $.messager.alert('��ʾ','�����ڶ��˼�¼','info');
		      return;
		   }	   
     $.messager.progress({
		title: "��ʾ",
		text: '���ڶ��������Ժ�....'
	 });
	 $.each(rows, function (index, row) {
				 if (!row.Rowid) {
				  	return true;
				 }
					if ((row.blFlag == "0")||(row.blFlag == "2")) {
					 var DivSumDr=row.Rowid;
		             //�������ɳɹ�,��ȡ�����������ݣ��ύ����
			         ExpString="^^"+DivSumDr+"^^";
			         var balRtn=InsuLiquidationAll(0,PUB_CNT.SSN.USERID,PUB_CNT.HITYPE,ExpString);
			         /*if(balRtn<0){
				     $.messager.alert('��ʾ','������ʧ��');
		         	}else{
			       	$.messager.alert('��ʾ','���������,��鿴���˽��');
			        }*/
					}
				 });
		       DivSumQuery_click();
	   }
   catch(ex)
	      {
		  }
   finally
	     {
		  $.messager.progress("close");
		 }
	
			
	/*
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ��һ����¼��');
		return;
	}
	var blFlag=selectedRow.blFlag;
	//if ((blFlag!="0")&&(blFlag!="������")&&(blFlag!="����ʧ��")){
	if ((blFlag=="3")||(blFlag == "��������")){
		$.messager.alert('��ʾ','�ü�¼����Ч״̬,���������ɶ������ݣ�');
		return;
	}
	var DivSumDr=selectedRow.Rowid;
	$.messager.progress({
		title: "��ʾ",
		text: '���ڶ��������Ժ�....'
	});
	  //�������ɳɹ�,��ȡ�����������ݣ��ύ����
		ExpString="^^"+DivSumDr+"^^";
		var balRtn=InsuLiquidationAll(0,PUB_CNT.SSN.USERID,PUB_CNT.HITYPE,ExpString);
		if(balRtn<0){
			$.messager.alert('��ʾ','������ʧ��');
		}else{
			$.messager.alert('��ʾ','���������,��鿴���˽��');
		}
	*/
		

}
//��ѯ���˽��
function DivSumQuery_click()
{
	if(LockFlag != "Y"){
		SetBtnIsDisabled();
	}
    var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx=$('#insutype').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	//var Options=$('#setlOptins').combobox('getValue');
	var Options=""
	
	var BlStas= $('#blStatus').combobox('getValue');
	var BlMod = $('#blModType').combobox('getValue');
	if(StDate==""||EndDate==""){
		$.messager.alert('ע��','�������ڲ���Ϊ�գ�','info');
		return;
	}
	if(hiType==""){
		$.messager.alert('ע��','ҽ�����Ͳ���Ϊ�գ�','info');
		return;
	}
	var ExpStr="||";
	//BusiType As %String = "", SetlOptions As %String = "", HiType As %String = "", RefdSetlFlag As %String = ""
	$HUI.datagrid('#ballist',{
		url:$URL+"?ClassName="+'INSU.MI.DAO.DivSum'+"&QueryName="+'InsuDivSumQuery'+"&StDate="+StDate+"&EndDate="+EndDate+"&ClrType="+ClrType+"&Xzlb="+Xzlx+"&UserId="+PUB_CNT.SSN.USERID+"&HospDr="+PUB_CNT.SSN.HOSPID+"&BusiType=1"+"&HiType="+PUB_CNT.HITYPE +"&RefdSetlFlag="+PUB_CNT.REFDSETLFLAG+"&SetlOptions="+Options+"&BlMod="+BlMod+"&BlStas="+BlStas+"&ExpStr="+ExpStr

	})
}

//���϶����˼�¼
function DivSumCreateDel_click()
{
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ��һ��Ҫ���ϵĶ��˼�¼��','info');
		return;
	}
	var blFlag=selectedRow.blFlag;
	//if ((blFlag!=0)&&(blFlag!="������")){
		//$.messager.alert('��ʾ','�ü�¼�Ƕ���״̬�����������ϣ�');
		//return;
	//}
	//
	var RowId=selectedRow.Rowid;
	//if ((blFlag==1)||(blFlag!="���˳ɹ�"))
	if ((blFlag==1)||(blFlag=="���˳ɹ�"))	//upt HanZH 20220930
	{
	 $.messager.confirm("������ʾ", "�����ѳɹ�,�Ƿ��������", function (rtn) {
       if(rtn){
	          _StrikeDivSumById(RowId);
	       }
       });
	}else{
		_StrikeDivSumById(RowId);
		}
}
//���϶�������
function _StrikeDivSumById(RowId){
	$m({
		ClassName: "INSU.MI.BL.DivMonstmtCtl",
		MethodName: "StrikeDivSumById",
		RowId: RowId,
		UserId:PUB_CNT.SSN.USERID,
		HospDr:PUB_CNT.SSN.HOSPID
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('��ʾ',"����ʧ�ܣ�"+rtn,'info');
		}
		//$.messager.alert('��ʾ',"");
		$.messager.popover({
				msg: '���ϳɹ�!',
				type: 'success',
				timeout: 2000, 		//0���Զ��رա�3000s
				showType: 'slide'  
			});
		DivSumQuery_click();
		ClearGrid("divdetdg");
	});
	
	}

//����ϸ��
function DivDetConfirm_click(){
	
	
	each()
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ��һ����¼��','info');
		return;
	}
	var blFlag=selectedRow.blFlag;
	if ((blFlag=="3")||(blFlag == "��������")){
		$.messager.alert('��ʾ','�ü�¼����Ч״̬,���������ɶ������ݣ�','info');
		return;
	}
	var DivSumDr=selectedRow.Rowid;
	$.messager.progress({
		title: "��ʾ",
		text: '���ڶ���ϸ�����Ժ�....'
	});
	$.messager.confirm("������ʾ", "�Ƿ��������ض�����ϸ����", function (rtn) {
       if(rtn){
		  
		   var ExpString="^^"+DivSumDr+"^"+PUB_CNT.DLALLFLAG+"^"
		  var rtn=InsuLiquidationMx(0,PUB_CNT.SSN.USERID,PUB_CNT.HITYPE,ExpString);
		  if(rtn<0){
			$.messager.alert('����','���ش���','info');
			$.messager.popover({
				msg: '����ϸ��ʧ�ܣ�Err='+rtn,
				type: 'error',
				style: {
					bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
					right: 10
				}
			});
			return;
		  }else{
			//$.messager.alert('��ʾ','������ϸ���');
			$.messager.popover({
				msg: '������ϸ���!',
				type: 'success',
				timeout: 2000, 		//0���Զ��رա�3000s
				showType: 'slide'  
			});
		  }
		  //SynRefdStelFlag();
        }
       //SetInsuUnusual(DivSumDr);
       // �������� ��֧��ԭ����Promise,��Ҫ���ò��,���dhcinsu.divmonstmt.csp 
       var mySynRefdPromise = new Promise(function(resolve, reject){
                  SynRefdStelFlag();
       });
       mySynRefdPromise.then(function(){
           SetInsuUnusual(DivSumDr);
      });
        
	});
	/*
	var urlStr=$URL+"?ClassName=web.DHCINSUBalanceDayCtl&QueryName=BalanceDayInfo&StDate="+StDate+"&EnDate="+EndDate+"&AdmType="+""+"&InsuType="+InsuType+"&HospId="+HospDr;
	$HUI.datagrid('#ballist',{
		url:urlStr
	});
	*/
}
 /* ��������
  *
  *
  */
function btnClrAppy_click () 
{
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ������һ����������˼�¼��','info');
		return;
	}
	var blMod=selectedRow.blMod;
	if ((blMod!="0"))
	   {
		$.messager.alert('��ʾ','��ѡ����˳ɹ����¼�¼��','info');
		return;
	   }
	var blFlag=selectedRow.blFlag;
	if ((blFlag!="1")&&(blFlag!="���˳ɹ�"))
	   {
		$.messager.alert('��ʾ','��ѡ����˳ɹ��ļ�¼��','info');
		return;
	   }
	var clrAppyStas=selectedRow.clrAppyStas;
	if ((blFlag=="I")||(blFlag=="������"))
	   {
		$.messager.alert('��ʾ','��ѡ��δ�������������Ķ��˼�¼��','info');
		return;
	   }

	var dHandle = 0 ;
	var setlYM = selectedRow.trtMonth;
	var hiType = selectedRow.insuType;
	var clrType=""; //Ϊ�� ����setlYMȫ��
	var clrWay="";
	var expStr=selectedRow.hospId+"^";
    var rtnFlag = InsuClrAppy(dHandle,PUB_CNT.SSN.USERID,setlYM,hiType,clrType,clrWay,expStr)  //DHCInsuPort.js
    if ((rtnFlag == "0"))
	   {
		$.messager.alert('��ʾ','��������ɹ���','success');
		DivSumQuery_click();
		return;
	   }
      $.messager.alert('��ʾ','��������ʧ�ܣ�'+rtnFlag,'error');
	  return;  
 }
/*�������볷�� 
 *
 *
 */
function btnClrAppyCancel_click () 
{
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ������һ���������¼��','info');
		return;
	}
	var clrAppyStas=selectedRow.clrAppyStas;
	if ((blFlag!="I")&&(blFlag=!"������"))
	   {
		$.messager.alert('��ʾ','��ѡ��������״̬�ļ�¼��','info');
		return;
	   }  
	   
	  $.messager.confirm("��Ҫ������ʾ", "�Ƿ����������������", function (flag) {
       if(flag)
         {
	          
	       	 var dHandle = 0;
			 var hiType = selectedRow.insuType;
			 var clrAppyEvtId=selectedRow.clrAppyEvtId;
			 var clrType = "";
			 var expStr=selectedRow.hospId+"^";
		     var rtnFlag = InsuClrAppyCancel(dHandle,PUB_CNT.SSN.USERID,clrAppyEvtId,hiType,clrType,expStr)  //DHCInsuPort.js  
		      if ((rtnFlag == "0"))
			   {
				$.messager.alert('��ʾ','�������볷���ɹ���','success');
				DivSumQuery_click();
				return;
			   }
		      $.messager.alert('��ʾ','�������볷��ʧ�ܣ�'+rtnFlag,'error');
			  return;  
	       }
       });    

}  
  
///ͬ���˷ѽ����ʶ
function SynRefdStelFlag()
{
	
	var EdDate=getValueById('endate');
	var trtMonth=EdDate.split("-")[0]+""+EdDate.split("-")[10];
	 $m({
		ClassName: "INSU.MI.BL.DivMonstmtCtl",
		MethodName: "SynRefdStelFlag",
		trtMonth: trtMonth,
		HospDr:PUB_CNT.SSN.HOSPID,
		HiType: PUB_CNT.HITYPE
	},function(rtn){
		if(rtn.split("^")[0]<0){
			//$.messager.alert('��ʾ',"ͬ���˷ѽ����ʶ�쳣��"+rtn);
			  $.messager.popover({
				msg: 'ͬ���˷ѽ����ʶ�쳣��"+rtn',
				type: 'success',
				timeout: 2000, 		//0���Զ��رա�3000s
				showType: 'slide'  
			});
		}else{
			   //$.messager.alert('��ʾ','ͬ���˷ѽ����ʶ���');
			   $.messager.popover({
				msg: 'ͬ���˷ѽ����ʶ���!',
				type: 'success',
				timeout: 1000, 		//0���Զ��رա�3000s
				showType: 'slide'  
			});
			   
			}
	  $.messager.progress("close");
	});
}



///�Ա��쳣����
function SetInsuUnusual(DivSumDr)
{
	 $m({
		ClassName: "INSU.MI.BL.DivMonstmtCtl",
		MethodName: "SetInsuUnusual",
		DivSumDr: DivSumDr,
		UserId:PUB_CNT.SSN.USERID,
		HospDr:PUB_CNT.SSN.HOSPID
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('��ʾ',"ͬ���쳣���ݴ���"+rtn,'info');
		}else{
			   $.messager.alert('��ʾ','ͬ�����','info');
			}
	  $.messager.progress("close");
	});
}

//��ѯ�쳣����
function DivUnusualQuery(DivSumDr)
{
	if(DivSumDr==""){
		return;
	}
	var UrlQry="ClassName=INSU.MI.DAO.Unusual&QueryName=DivUnusualQuery&blDivSumDr="+DivSumDr+"&HospDr="+PUB_CNT.SSN.HOSPID+"&UserId="+PUB_CNT.SSN.USERID;
	var urlStr=$URL+"?"+UrlQry+"&blFlag=1"
	$HUI.datagrid('#centererrdg',{
		url:urlStr
	});
	var urlStr=$URL+"?"+UrlQry+"&blFlag=0"
	//var urlStr=$URL+"?ClassName=INSU.MI.DAO.Unusual&QueryName=DivUnusualQuery&blDivSumDr="+DivSumDr+"&HospDr="+PUB_CNT.SSN.HOSPID+"&UserId="+PUB_CNT.SSN.USERID+"&blFlag=0";
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
	var ClrType=$('#clrType').combobox('getValue');
	/*	WangXQ  20221024
	if(ClrType == ""){
		$.messager.alert('��ʾ','���������Ϊ��','info');
		return;
	}*/
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	$.messager.progress({
		title: "��ʾ",
		text: '����ͬ��HISҽ�������������Ժ�....'
	});

	// ��ȡ�������
	$m({
		ClassName: "INSU.MI.BL.DivMonstmtCtl",
		MethodName: "SynHisDivInfo",
		StDate: StDate,
		EndDate: EndDate,
	    UserId: PUB_CNT.SSN.USERID,
		HospDr: PUB_CNT.SSN.HOSPID,
		HiType:PUB_CNT.HITYPE,
		HAdmType:''
	},function(rtn){
		$.messager.progress("close");
		if((rtn.split("^")[0])<0){
			$.messager.alert('��ʾ','ͬ��HISҽ���������ݷ�������rtn='+rtn,'info');
			return;	
		}else{
			 $.messager.alert('��ʾ','ͬ��HISҽ���������ݳɹ�:'+rtn,'info','info');
			}
		DivSumQuery_click();
	});
}


function initDate(){
	var today=new Date();
	date=new Date(today.getTime()-24*60*60*1000);
	var s0=date.getFullYear()+"-"+(date.getMonth())+"-"+"01" //date.getDate();
	var s1="" //date.getFullYear()+"-"+(date.getMonth())+"-"+getSpanDays(date.getMonth()) 
	if(PUB_CNT.BLMOD=="1"){s1=s0;}
	else{s1=date.getFullYear()+"-"+(date.getMonth())+"-"+getSpanDays(date.getMonth())}
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
			var EdDate="";
			if(PUB_CNT.BLMOD=="1"){ EdDate=StDate;}
	         else{
		            EdDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+(date.getDate()+getSpanDays(date.getMonth()+1)-1);
		          }
			if (PUB_CNT.SYSDTFRMT()==4)
	        {
		       StDate=date.getDate()+"/"+(date.getMonth()+1)+"/"+date.getFullYear();
		       if(PUB_CNT.BLMOD=="1"){ EdDate=StDate;}
	           else{
		             EdDate=(date.getDate()+getSpanDays(date.getMonth()+1)-1)+"/"+(date.getMonth()+1)+"/"+date.getFullYear();
		            }
	           
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
			
		},
	});
	
	//if(PUB_CNT.BLMOD=="1"){ $('#endate').datebox({disabled: true})}
	
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

function btnImportDet(){

	var selectedRow = $('#ballist').datagrid('getSelected');
	/*if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ������˵ļ�¼��');
		return;
	}
	if(selectedRow.blFlag!="������"){
		$.messager.alert('��ʾ','�Ǵ�����״̬�������������ϸ��');
		return;
	}*/
	var DivSumDr = "",TrtMonth="";
	var trtMonth="";
	if(selectedRow){
	  if((selectedRow.blFlag=="��������")||(selectedRow.blFlag=="3")){
		$.messager.alert('��ʾ','��ѡ��һ����Ч��¼','info');
		return;
	}
	  DivSumDr = selectedRow.Rowid ||  "";
	  TrtMonth=selectedRow.trtMonth;
	}
	var BusiType="1";
	
	if(DivSumDr =="")
	{
		var encdate=getValueById("endate");
		if(encdate==""){$.messager.alert('��ʾ','�������ڲ���Ϊ��','info');return;}
		var trtMonth=(encdate.slice(0,8)).replace("-","");
	}
	
	if($('#_efinput').length != 0){$('#_efinput').val("");$("#_efinput").empty();$("#_efinput").remove();}
	var inputObj=document.createElement('input')
	inputObj.setAttribute('id','_efinput');
	inputObj.setAttribute('type','file');
	inputObj.setAttribute("style",'visibility:hidden');
	document.body.appendChild(inputObj);
	inputObj.addEventListener("change", 
	function(){
	    var file = inputObj.files[0];
	    if((file==null)||(file==undefined)) return;
	 $.messager.progress({
		title: "��ʾ",
		text: '���ڵ���ҽ��������ϸ����....'
	});
	    var form = new FormData();
	    form.append("FileStream", file); //��һ�������Ǻ�̨��ȡ������keyֵ
	    form.append("fileName", file.name);
	    $.ajax({
	        url:jsonQueryUrl+'INSU.MI.BL.DivMonstmtCtl'+SplCode+"ImporCenterDivInfoFromCSV"+SplCode+DivSumDr+ArgSpl+PUB_CNT.SSN.USERID+ArgSpl+PUB_CNT.SSN.HOSPID+ArgSpl+BusiType+ArgSpl+TrtMonth+ArgSpl+PUB_CNT.HITYPE,
	        type:'post',
	        data: form,
	        contentType: false,
	        processData: false,
	        success:function(res){
	            console.log(res);
	            if((res=="0")||(res=="\r\n0")){
		            $.messager.alert('��ʾ','������ϣ�','info');
		        }else{
					$.messager.alert('��ʾ','����ʧ��: ' + res,'info');   
				}
				$.messager.progress("close");
				DivSumQuery_click();
				
	        }
	    })
	  },false);
	inputObj.click();
}

 //���������HIS����(�ʺ�,��������ҽ���ӿ����)����(��ϵͳ���ݡ�������������ҽ��֧��)
function btnImportThirdDet(){
	
	var hiType=$('#hiType').combobox('getValue');
	if(hiType==""){
		$.messager.alert('��ʾ','����ѡ��ҽ�����','info');
		return;
	}
	var selectedRow = $('#ballist').datagrid('getSelected');
	/*if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ������˵ļ�¼��');
		return;
	}
	if(selectedRow.blFlag!="������"){
		$.messager.alert('��ʾ','�Ǵ�����״̬�������������ϸ��');
		return;
	}*/
	var DivSumDr = "",trtMonth="";
	var TrtMonth=""
	var trtMonth=getValueById("endate");
	if(selectedRow){
	  if((selectedRow.blFlag=="��������")||(selectedRow.blFlag=="3")){
		$.messager.alert('��ʾ','��ѡ��һ����Ч��¼','info');
		return;
	}
	  DivSumDr = selectedRow.Rowid ||  "";
	  TrtMonth=selectedRow.trtMonth;
	}
	var BusiType="1";
    if(DivSumDr =="")
	{
		var encdate=getValueById("endate");
		if(encdate==""){$.messager.alert('��ʾ','�������ڲ���Ϊ��','info');return;}
		var trtMonth=(encdate.slice(0,8)).replace("-","");
	}

	if($('#_efinputThd').length != 0){$('#_efinputThd').val("");$("#_efinputThd").empty();$("#_efinputThd").remove();}
	var inputObj=document.createElement('input')
	inputObj.setAttribute('id','_efinputThd');
	inputObj.setAttribute('type','file');
	inputObj.setAttribute("style",'visibility:hidden');
	document.body.appendChild(inputObj);
	inputObj.addEventListener("change", 
	function(){
	    var file = inputObj.files[0];
	    var filename=file.name
	    //��ȡ���һ��.��λ��
		var fileindex= filename.lastIndexOf(".");
		//��ȡ��׺
		var ext = filename.substr(fileindex+1);
	    if(ext!="txt")
	    {
		    $.messager.alert('��ʾ','�뵼��txt�����ļ���','info');
		    return
		    }
	    if((file==null)||(file==undefined)) return;
	    $.messager.progress({
		 title: "��ʾ",
		 text: '���ڵ��������ҽ������....'
	    });
	    var form = new FormData();
	    form.append("FileStream", file); //��һ�������Ǻ�̨��ȡ������keyֵ
	    form.append("fileName", file.name);
	    $.ajax({
	        url:jsonQueryUrl+'INSU.MI.BL.DivMonstmtCtl'+SplCode+'ImportHisDivInfoFromCSV'+SplCode+DivSumDr+ArgSpl+PUB_CNT.SSN.USERID+ArgSpl+PUB_CNT.SSN.HOSPID+ArgSpl+BusiType+ArgSpl+TrtMonth+ArgSpl+PUB_CNT.HITYPE,
	        type:'post',
	        data: form,
	        contentType: false,
	        processData: false,
	        success:function(res){
	            console.log(res);
				$.messager.progress("close");
				DivSumQuery_click();
				var pidNum=res.split("^")
				var pid=pidNum[1]
			   websys_showModal({				//���뵯������ WangXQ 20220627
				   url: "dhcinsu.divmonstmtimportresult.csp?&Pid=" + pid,
				   title: "�����¼",
				   iconCls: "icon-w-list",
				   width: "1140",
				   height: "560",
				   onClose: function () {
						kImportDataGlobal(pid);
					}  
		   
			   });
	        }
	    })
	  },false);
	inputObj.click();
}
//����ҽ�������쳣(����)
function btnStrikeForInsu()
{
	var selectedRow = $('#centererrdg').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ��ҽ���쳣�ļ�¼��','info');
		return;
	}
	
	var rtncode=-1;
	var clrOptins=selectedRow.clrOptins;
	var Rowid=selectedRow.Rowid;
	var djlsh=selectedRow.djlsh;
	var hiType=$('#hiType').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	var ExpString="^^"+selectedRow.psnno+"^"+selectedRow.zylsh+"^"+selectedRow.InsuTotAmt+"^"+selectedRow.msgid+"^"+ClrType+"^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
	if((ClrType=="11")||(ClrType=="41")){
		//Handle,UserId,djlsh0,AdmSource,AdmReasonId,ExpString,CPPFlag)
		rtncode=InsuOPDivideCancleForInsu(0,PUB_CNT.SSN.USERID,djlsh,hiType,"",ExpString)
	}else{
		rtncode=InsuIPDivideCancleForInsu(0,PUB_CNT.SSN.USERID,djlsh,hiType,"",ExpString)
	}
	if(rtncode!="0") {
		$.messager.alert('��ʾ','����ʧ��: ' + rtncode,'info');
	}else{
		$.messager.alert('��ʾ','������ϣ����ҽ����HIS��û���쳣�Ϳ����ٴζ�������','info');
		var hndInfo="1^"+PUB_CNT.SSN.USERID;
		UpdUnusualHndInfo(Rowid,hndInfo) ;//�����쳣��������Ϣ DingSH 20210512
		var dgindex = $('#centererrdg').datagrid('getRowIndex', selectedRow);
		selectedRow.hndFlag="�ѳ���";
		selectedRow.hndFUser=Guser;
	    $('#centererrdg').datagrid('updateRow',{index: dgindex,row:selectedRow});
	}
}
///�����쳣������Ϣ
function UpdUnusualHndInfo(rowid,hndInfo){
	
	$.m({
		ClassName: "INSU.MI.DAO.Unusual",
		MethodName: "UpdUnusualHndInfo",
		type: "GET",
		rowid: rowid,
		hndInfo: hndInfo
	}, function (rtn) {
       if (rtn.split("^")[0]>0) {$.messager.alert('��ʾ','�������','info');}
       else{{$.messager.alert('��ʾ','�����쳣'+rtn,'info');}}
	});	
	
	}
function btnStrikeForHis()
{
	var selectedRow = $('#centererrdg').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ��ҽ���쳣�ļ�¼��','info');
		return;
	}
	var rtncode=-1;
	var clrOptins=selectedRow.clrOptins;
	var Rowid=selectedRow.Rowid;
	var blHisDivDr="";
	var BillNo="";
	//selectedRow.psnno,selectedRow.zylsh,selectedRow.InsuTotAmt,selectedRow.djlsh
	blHisDivDr=tkMakeServerCall("INSU.MI.DAO.Unusual","GetDivByStr",selectedRow.psnno,selectedRow.djlsh,selectedRow.zylsh,selectedRow.InsuTotAmt);
	if(blHisDivDr==""){$.messager.alert('��ʾ','δ��λ��HISҽ��������쳣�ļ�¼��','info');return ;}
	var ExpString="^^"+selectedRow.psnno+"^"+selectedRow.zylsh+"^"+selectedRow.InsuTotAmt+"^"+selectedRow.msgid+"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
	
	var hiType=$('#hiType').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	if((ClrType=="11")||(ClrType=="41")){
		
		rtncode=InsuOPDivideCancleForHis(0,PUB_CNT.SSN.USERID,blHisDivDr,hiType,"",ExpString,"")
	}else{
		var divstr=tkMakeServerCall("web.DHCINSUDivideCtl","GetDivById",blHisDivDr);
		if(divstr.length>10){
			BillNo=divstr.split("^")[3]
			if(BillNo=="") {$.messager.alert('��ʾ','δ�ҵ��˵��ţ�','info');return;}
		}
		
		rtncode=InsuIPDivideCancleForHis(0,PUB_CNT.SSN.USERID,BillNo,hiType,"",ExpString)
	}
	if(rtncode!="0") {
		$.messager.alert('��ʾ','����ʧ��: ' + rtncode); 
	}else{
		$.messager.alert('��ʾ','������ϣ����ҽ����HIS��û���쳣�Ϳ����ٴζ�������','info');
		var hndInfo="1^"+Guser;
		UpdUnusualHndInfo(Rowid,hndInfo) ;//�����쳣��������Ϣ DingSH 20210512
	}
}
//����
function ShwBlRsDialog(field, value, rowIndex) {
	if (field == "stmtRsltDscr")
	{
	 $('#blResult').val(value);
	 $('#ShwBlRsdl').window('open');
	}
}

//���������쳣����
function btnCenterErrEpot()
{
	
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ������˵ļ�¼��','info');
		return;
	}
	
	var DivSumDr=selectedRow.Rowid;
	
	UnusualEpot(DivSumDr,1)
}

//����HIS�쳣����
function btnHisErrEpot()
{
	
	var selectedRow = $('#ballist').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ������˵ļ�¼��','info');
		return;
	}
	
	var DivSumDr=selectedRow.Rowid;
	
	UnusualEpot(DivSumDr,0)
}

//�쳣���ݵ���
function UnusualEpot(DivSumDr,blFlag)
{
	
	var ExcelName="hiserrr"+getExcelFileName()
	if (blFlag==1){
		ExcelName="centererr"+getExcelFileName();
		}
	$.messager.progress({
			   title: "��ʾ",
			   msg: '���ڵ����쳣����',
			   text: '������....'
		   });
	var rtn = tkMakeServerCall("websys.Query","ToExcel",ExcelName,"INSU.MI.DAO.Unusual","DivUnusualQuery",DivSumDr,PUB_CNT.SSN.HOSPID,PUB_CNT.SSN.USERID,blFlag,"1");
	location.href = rtn ; 	
	setTimeout('$.messager.progress("close");', 3 * 1000);
  /* try
   {
   var rtn = $cm({
   dataType:'text',
   ResultSetType:"Excel",
   ExcelName:"err", //Ĭ��DHCCExcel
   ClassName:"INSU.MI.DAO.Unusual",
   QueryName:"DivUnusualQuery",
   blDivSumDr:DivSumDr,
   HospDr:HospDr,
   UserId:Guser,
   blFlag:blFlag
	},false);
	
	alert("rtn="+rtn)
	location.href = rtn;
   $.messager.progress({
			   title: "��ʾ",
			   msg: '���ڵ����쳣����',
			   text: '������....'
		   });
   setTimeout('$.messager.progress("close");', 3 * 1000);	
	   
	  
   } catch(e) {
	   $.messager.alert("����",e.message);
	   $.messager.progress('close');
   };*/

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

//�رյ���ʱ���ú�̨kill global WangXQ 20220629
function kImportDataGlobal(Pid){
	
	tkMakeServerCall("INSU.MI.DAO.HisDivInfo","kImportDataGlobal",Pid);
	}

// +20230301 ��ʼ��ҽ�ƻ���
function initInsuHospCmb(){
 $HUI.combobox('#InsuHospCode',{   
	    url:$URL,
		editable:false,
		valueField:'cCode',
		textField:'cDesc',
		method:'GET',
		onBeforeLoad:function(param){
			param.ClassName='web.INSUDicDataCom';
			param.QueryName='QueryDic';
			param.ResultSetType='array';
			param.Type=('InsuHospCode'+PUB_CNT.HITYPE);
			param.Code='';
			param.HospDr=PUB_CNT.SSN.HOSPID;	
		},
		value: ''
	}); 
}

//��ʼ���������� +20230301
function initBlModType(){ 
	$HUI.combobox('#blModType', {
		panelHeight: 'auto',
		data: [{
				value: '0',
				text: '�¶���',
				'selected':true
			}, {
				value: '1',
				text: '�ն���'
			}
		],
		valueField: 'value',
		textField: 'text'
	  });
}
//��ʼ������״̬ +20230301
function initBlStatus(){
	  $HUI.combobox('#blStatus', {
		panelHeight: 'auto',
		data: [{
				value: '0',
				text: 'δ����'
				//'selected':true
			}, {
				value: '1',
				text: '���˳ɹ�'
			}, {
				value: '2',
				text: '����ʧ��'
			}, {
				value: '3',
				text: 'HIS��������'
			}
		],
		valueField: 'value',
		textField: 'text'
	  });
}
function checkLock(){
	try{
		var rtn = tkMakeServerCall("INSU.MI.DAO.DivSum","CheckDivSumLock",session['LOGON.USERCODE'],session['LOGON.USERNAME'],session['LOGON.HOSPID']);
		if(rtn.split("^")[0] != "1"){
			$.messager.popover({
				msg: '��Ǹ�������ڱ���������ֻ�ܲ�ѯ�������ˣ�' + rtn,
				type: 'info',
				timeout: 4000, 		//0���Զ��رա�3000s
				showType: 'slide'  
			});
			$('.hisui-linkbutton:not(#btnDivSumQuery)').linkbutton('disable');
			$('#btnStrikeForHis,#btnStrikeForInsu').hide();
			LockFlag = "Y";
		}
	}catch(e){
		return true;
	}
}	
//��ձ������
function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
}
/*
 * �����뿪�����ʱ��
 * 2023-04-14 DingSH  
 * Juquery 1.8 �Ѿ�����
 */
 $(window).unload(function(){
 	ReleaseDivSumLock();
});

/*
 * �����뿪�����ʱ��
 * �µ�chrome�£���visibilitychange�滻unload�¼�
 *  2023-04-14 DingSH 
 */
window.addEventListener("beforeunload",function(e){
      e.preventDefault();
 	  e.returnValue = '';
	  ReleaseDivSumLock();
});
/*
 *�����ʱ��
 */
function ReleaseDivSumLock(){
	
	try{
		$.cm({
				ClassName: "INSU.MI.DAO.DivSum",
				MethodName: "ReleaseDivSumLock",
				type: "BEACON",  //�������涨������
				OptUserCode: session['LOGON.USERCODE'],
				OptHosp: session['LOGON.HOSPID']
			});
		}catch(ex){}
	}