/**
* FillName: dhcinsu/divmonstmtmx.js
* Description: ҽ������ϸ��
* Creator DingSH
* Date: 2021-07-12
*/
// ���峣��
var PUB_CNT = {
	HITYPE:'',                               //ҽ������
	REFDSETLFLAG:'1',                        //�˷ѽ����־��Ϊ0ʱ�����˶������ݲ������˷����ݣ�Ϊ1����ֵ��null��ȱʡʱ�����˶������ݰ����˷����ݣ�
	DLALLFLAG:'1',                           //�Ƿ���Դ����ļ�����ȫ����ϸ1/0
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
	
	//��ʼ����ƽ��ʶ
	initErrFlagCmb();
	
	//��ʼ�˷ѽ����ʶ
	initRefdSetlFlagCmb();
	
	//HIS������ϸ
	initHisDivDetDgDg();
	
	//ҽ��������ϸ
	initCenterDivDetDg();

}
//����ҳ��Ԫ���¼�
function setElementEvent()
{
	
	 //ͬ��HIS��������
    $("#btnSynHisDiv").click(function () {
        SynHisDiv();
    });
 
      /*��ѯ*/
	 $("#btnDivQuery").click(function () {
        DivHisQuery_click();
        DivCenterQuery_click();
    });
   

   /*����*/
    $("#btnDivStmt").click(function () {
        DivStmt_Click();
    });
    
    /*ҽ������ϸ����*/
    $("#btnCenterDivDL").click(function () {
        CenterDivDL_click();
    });
	
    /*����ҽ����ϸ--��Ҫ���չ涨��ʽ�ṩ����*/
    $("#btnImportCenterDiv").click(function () {
        btnImportCenterDiv();
    });
	/*����ҽ�������쳣*/
	$('#btnStrikeForInsu').click(function(){
		var oldOk = $.messager.defaults.ok;
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
	$('#btnStrikeForHis').click(function(){btnStrikeForHis()});
	/*�������������ForHIS,�ʺϵ�������ҽ�����Ľ�������*/
	$('#btnImportThirdDet').click(function(){btnImportThirdDet();});
	/*���������쳣*/
	$('#btnCenterDivEpot').click(function(){btnCenterDivEpot();});
	/*����HIS�쳣*/
	$('#btnHisDivEpot').click(function(){btnHisDivEpot();});
  
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
		onLoadSuccess:function(){
			$('#hiType').combobox('select','00A');
			},
		onSelect:function(rec){
			PUB_CNT.HITYPE = rec.cCode;
			initSetlOptinsCmb();
			initInsutypeCmb();
			initClrTypeCmb();
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
		value: '11'
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
//��ʼ���쳣��ʶ
function initErrFlagCmb()
{
	$HUI.combobox('#errFlag',{
		//url:$URL,
		editable:false,
		valueField:'cCode',
		textField:'cDesc',
		data:[
		       {cCode:"",cDesc:"ȫ��"},
		       {cCode:"1",cDesc:"��"},
		       {cCode:"0",cDesc:"��"}
		      ],
		 value:''
	});
}
//��ʼ���˷ѽ����ʶ
function initRefdSetlFlagCmb()
{
	$HUI.combobox('#refdSetlFlag',{
		//url:$URL,
		editable:false,
		valueField:'cCode',
		textField:'cDesc',
		data:[
		       {cCode:"",cDesc:"ȫ��"},
		       {cCode:"1",cDesc:"��"},
		       {cCode:"0",cDesc:"��"}
		      ],
		 value:''
		
	});
}
//��ʼ��HIS������ϸdg
function initHisDivDetDgDg()
{
	 $HUI.datagrid('#HisDivDetDg',{
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		singleSelect: true,
		pageSize:20,
		pageList:[10, 20, 30],
		pagination:true,
		fitColumns:false,
		frozenColumns:[[
		    {field:'patNo',title:'�ǼǺ�',width:120},
		    {field:'psnName',title:'����',width:100},
		    {field:'stRslt',title:'��ƽ',width:60,align:'center',styler: function(value,row,index){
				        var rtnStyle="background-color:#EE4F38;color:white";
					    if (row.DivCenterDr>0)
					    {
	    		            rtnStyle= 'background-color:#51B80C;color:white';
	                     }	
					return rtnStyle;
				},
				formatter: function(value,row,index){
				if (row.DivCenterDr>0){
					return "��";
				} else {
					return "��";
				}
			   }
			},
		    {field:'djlsh',title:'�����¼�Id',width:150},
		    {field:'zylsh',title:'�����¼�Id',width:150}
		]],
		columns:[[
		    
		    {field:'msgid',title:'���ͻ�������ˮ��',width:260},
		    {field:'psnno',title:'���˱��',width:150},
		    {field:'PsnCertType',title:'֤������',width:150},
		    {field:'Certno',title:'֤������',width:150},
			{field:'RefdSetlFlag',title:'�˷ѽ����ʶ',width:120},
			{field:'Xzlb',title:'��������',width:150,hidden:true},
			{field:'XzlbDesc',title:'��������',width:150},
			{field:'ClrType',title:'�������',width:80,hidden:true},
			{field:'ClrTypeDesc',title:'�������',width:80},
			{field:'HisTotAmt',title:'�ܽ��',width:100,align:'right'},
			{field:'HisJjzfe',title:'����֧���ܶ�',width:100,align:'right'},
			{field:'HisZhzfe',title:'�˻�֧���ܶ�',width:100,align:'right'},
			{field:'HisGrzfe',title:'�����Ը��ܶ�',width:100,align:'right'},
			{field:'blFlag',title:'���˱�־',width:100,hidden:true},
			{field:'ClrOptins',title:'���㾭�����',width:150},
			{field:'SetlOptins',title:'���㾭�����',width:120},
			{field:'DivDate',title:'��������',width:120},
			{field:'DivTime',title:'�����¼�',width:120},
			{field:'AdmDate',title:'��������',width:120},
			{field:'DisDate',title:'��Ժ����',width:120},
			{field:'LocName',title:'�������',width:120},
			{field:'AdmType',title:'ҽ�����',width:120},
			{field:'PatType',title:'��Ա����',width:120},
			{field:'DivType',title:'��������',width:120},
			{field:'InsuOptins',title:'�α�ͳ������',width:120},
			{field:'BusiType',title:'ҵ����',width:120,hidden:true},
			{field:'HiType',title:'ҽ������',width:100},
			{field:'Rowid',title:'Rowid',width:80,hidden:true},
			{field:'DivideDr',title:'DivideDr',width:80,hidden:true},
			{field:'AdmDr',title:'AdmDr',width:80,hidden:true},
			{field:'DivCenterDr',title:'DivCenterDr',width:80,hidden:true},
			{field:'DivSumDr',title:'DivSumDr',width:80,hidden:true}
		]],
        onSelect:function(rowIndex, rowData) {
	        //SetBtnIsDisabled(rowData.blFlagDesc);
            //DivUnusualQuery(rowData.Rowid);
            //DivDetQuery();
        },
      
        onUnselect:function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
		onDblClickRow:function(rowIndex,rowData){
				
		}
	});
}
//��ʼ��ҽ��������ϸdg
function initCenterDivDetDg()
{
	 $HUI.datagrid('#CenterDivDetDg',{
		rownumbers:true,
		split:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		singleSelect: true,
		pageSize:20,
		pageList:[10, 20, 30],
		//toolbar:'#dgTB',
		pagination:true,
		fitColumns:false,
		frozenColumns:[[
			{field:'stRslt',title:'��ƽ',width:60,align:'center',styler: function(value,row,index){
					        var rtnStyle="background-color:#EE4F38;color:white";
						    if (row.blHisDivDr>0)
						    {
		    		            rtnStyle= 'background-color:#51B80C;color:white';
		                     }	
						return rtnStyle;
					},
					formatter: function(value,row,index){
						
				   if (row.blFlag == '3'){
						   return "����";
						}
					if (row.blHisDivDr>0){
						return "��";
					} else {
						return "��";
					}
					
					
				   }
				},
			    {field:'djlsh',title:'�����¼�Id',width:150},
			    {field:'zylsh',title:'�����¼�Id',width:150}
		]],
		columns:[[
		    //{field:'patNo',title:'�ǼǺ�',width:150},
		    //{field:'psnName',title:'����',width:100},
		    
		    {field:'msgid',title:'���ͻ�������ˮ��',width:260},
		    {field:'psnno',title:'���˱��',width:150},
		    {field:'PsnCertType',title:'֤������',width:150},
		    {field:'Certno',title:'֤������',width:150},
			{field:'RefdSetlFlag',title:'�˷ѽ����ʶ',width:120},
			{field:'Xzlb',title:'��������',width:150,hidden:true},
			{field:'XzlbDesc',title:'��������',width:150},
			{field:'ClrType',title:'�������',width:80,hidden:true},
			{field:'ClrTypeDesc',title:'�������',width:80},
			{field:'InsuTotAmt',title:'�ܽ��',width:100,align:'right'},
			{field:'InsuJjzfe',title:'����֧���ܶ�',width:100,align:'right'},
			{field:'InsuZhzfe',title:'�˻�֧���ܶ�',width:100,align:'right'},
			{field:'InsuGrzfe',title:'�����Ը��ܶ�',width:100,align:'right'},
			{field:'blFlag',title:'���˱�־',width:100,hidden:true},
			{field:'ClrOptins',title:'���㾭�����',width:150},
			{field:'AdmType',title:'ҽ�����',width:120},
			{field:'PatType',title:'��Ա����',width:120},
			{field:'DivType',title:'��������',width:120},
			{field:'BusiType',title:'ҵ����',width:120,hidden:true},
			{field:'HiType',title:'ҽ������',width:100},
			{field:'Rowid',title:'Rowid',width:80,hidden:true},
			{field:'blHisDivDr',title:'blHisDivDr',width:80,hidden:true},
			{field:'blDivSumDr',title:'blDivSumDr',width:80,hidden:true}
		]],
        onSelect:function(rowIndex, rowData) {
	        SetBtnIsDisabled(rowData.blFlagDesc);
            DivUnusualQuery(rowData.Rowid);
            DivDetQuery();
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
                disableById("btnDivSumCreateDel");    /*���϶�������*/
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
		//toolbar:'#dgTB',
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



//���� 
function DivStmt_Click()
{
	var ClrType=getValueById('clrType');
	var StDate=getValueById('stdate');
	var EndDate=getValueById('endate');
	
	 if(ClrType==""){
		$.messager.alert('ע��','���������Ϊ�գ�');
		return;
	 }
 	if(StDate==""||EndDate==""){
		$.messager.alert('ע��','�������ڲ���Ϊ�գ�');
		return;
	 }
	 $.messager.progress({
		title: "��ʾ",
		text: '��������������ϸ���Ժ�....'
	 });
	 try{
	    //ͬ���˷ѽ����ʶ
		SynRefdStelFlag();
		//ͬ��������ϸ����
		SynDivDetStmt();
		DivHisQuery_click();
        DivCenterQuery_click();
        
	 }
	 catch(ex){}
	 finally
	 {
			 
		$.messager.progress("close"); 
	 }
}

///ͬ��������ϸ����
function SynDivDetStmt()
{
	var Xzlb=getValueById('insutype');
	var ClrType=getValueById('clrType');
	var StDate=getValueById('stdate');
	var EdDate=getValueById('endate');
	 $m({
		ClassName: "INSU.MI.BL.DivMonstmtCtl",
		MethodName: "SynDivDetStmt",
		StDate: StDate,
		EdDate: EdDate,
		HiType: PUB_CNT.HITYPE,
		ClrType:ClrType,
		Xzlb:Xzlb,
		BusiType:'1',
		RefdSetlFlag:"",
		SetlOptions:"",
		UserId:PUB_CNT.SSN.USERID,
		HospDr:PUB_CNT.SSN.HOSPID
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('��ʾ',"ͬ�������쳣��"+rtn);
		}else{
			   $.messager.alert('��ʾ','ͬ���������');
			}
	  
	});
}

///ͬ���˷ѽ����ʶ
function SynRefdStelFlag()
{
	
	var EdDate=getValueById('endate');
	var trtMonth=EdDate.split("-")[0]+""+EdDate.split("-")[1];
	 $m({
		ClassName: "INSU.MI.BL.DivMonstmtCtl",
		MethodName: "SynRefdStelFlag",
		trtMonth: trtMonth,
		HospDr:PUB_CNT.SSN.HOSPID,
		HiType: PUB_CNT.HITYPE
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('��ʾ',"ͬ���˷ѽ����ʶ�쳣��"+rtn);
		}else{
			   $.messager.alert('��ʾ','ͬ���˷ѽ����ʶ���');
			}
	  $.messager.progress("close");
	});
}

//��ѯHIS������ϸ
function DivHisQuery_click()
{
    var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx=$('#insutype').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	var Options=$('#setlOptins').combobox('getValue');
	var ErrFlag=getValueById('errFlag');
	var refdSetlFlag=getValueById('refdSetlFlag');
	/*if(ClrType==""){
		$.messager.alert('ע��','���������Ϊ�գ�');
		return;
	}*/
	if(StDate==""||EndDate==""){
		$.messager.alert('ע��','�������ڲ���Ϊ�գ�');
		return;
	}
	if(hiType==""){
		$.messager.alert('ע��','ҽ�����Ͳ���Ϊ�գ�');
		return;
	}
	//BusiType As %String = "", SetlOptions As %String = "", HiType As %String = "", RefdSetlFlag As %String = ""
	$HUI.datagrid('#HisDivDetDg',{
		url:$URL+"?ClassName="+'INSU.MI.DAO.HisDivInfo'+"&QueryName="+'HisDivQuery'+"&StDate="+StDate+"&EdDate="+EndDate+"&ClrType="+ClrType+"&Xzlb="+Xzlx+"&UserId="+PUB_CNT.SSN.USERID+"&HospDr="+PUB_CNT.SSN.HOSPID+"&BusiType=1"+"&HiType="+PUB_CNT.HITYPE +"&RefdSetlFlag="+refdSetlFlag+"&SetlOptions="+Options+"&ErrFlag="+ErrFlag    

	})
}


//��ѯҽ��������ϸ
function DivCenterQuery_click()
{
	
    var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx=$('#insutype').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	var ErrFlag=getValueById('errFlag')
	//var Options=$('#setlOptins').combobox('getValue');
	var refdSetlFlag=getValueById('refdSetlFlag');
	/*if(ClrType==""){
		$.messager.alert('ע��','���������Ϊ�գ�');
		return;
	}*/
	
	if(StDate==""||EndDate==""){
		$.messager.alert('ע��','�������ڲ���Ϊ�գ�');
		return;
	}
	if(hiType==""){
		$.messager.alert('ע��','ҽ�����Ͳ���Ϊ�գ�');
		return;
	}
	//BusiType As %String = "", SetlOptions As %String = "", HiType As %String = "", RefdSetlFlag As %String = ""
	$HUI.datagrid('#CenterDivDetDg',{
		url:$URL+"?ClassName="+'INSU.MI.DAO.CenterDivInfo'+"&QueryName="+'CenterDivQuery'+"&StDate="+StDate+"&EdDate="+EndDate+"&ClrType="+ClrType+"&Xzlb="+Xzlx+"&UserId="+PUB_CNT.SSN.USERID+"&HospDr="+PUB_CNT.SSN.HOSPID+"&BusiType=1"+"&HiType="+PUB_CNT.HITYPE +"&RefdSetlFlag="+refdSetlFlag+"&ErrFlag="+ErrFlag   

	})
}

//ҽ��������ϸ����
function CenterDivDL_click(){
	
	/*var xzlb=getValueById('insutype');
	if(xzlb==""){
		$.messager.alert('ע��','���������Ϊ�գ�');
		return;
	}*/
	var xzlb="";
	var clrType=getValueById('clrType');
	if(clrType==""){
		$.messager.alert('ע��','���������Ϊ�գ�');
		return;
	}
	var stdate=getValueById('stdate');
	if(stdate==""){
		$.messager.alert('ע��','��ʼ���ڲ���Ϊ�գ�');
		return;
	}
	var endate=getValueById('endate');
	if(endate==""){
		$.messager.alert('ע��','�������ڲ���Ϊ�գ�');
		return;
	}
	var setlOptins=getValueById('setlOptins');

	if(setlOptins==""){
		   //$.messager.alert('ע��','���㾭���������Ϊ��');
		   //return
		    var oldOk = $.messager.defaults.ok;
		    var oldCancel = $.messager.defaults.cancel;
			$.messager.defaults.ok = "��";
			$.messager.defaults.cancel = "��";
			$.messager.confirm("��Ҫ��ʾ", "���㾭�����Ϊ��,�Ƿ�ȫ������ҽ��������ϸ?", function (r) {
		    if (r) {
             DLDivCenter();
		    }
			$.messager.defaults.ok = oldOk;
			$.messager.defaults.cancel = oldCancel;
	
	     });
        
   }else
   {
	   DLDivCenter();
 }
  				
   
 //SynDivDetStmt();
}


function DLDivCenter()
{
	var xzlb="";
	var clrType=getValueById('clrType');
	var stdate=getValueById('stdate');
	var endate=getValueById('endate');
	var setlOptins=getValueById('setlOptins');
	$.messager.progress({
	            title: "��ʾ",
	            text: '��������������ϸ���Ժ�....'
             });
		var ExpString="^^^"+PUB_CNT.DLALLFLAG+"^^"+clrType+"^"+xzlb+"^"+stdate+"^"+endate+"^"+setlOptins+"^"+PUB_CNT.REFDSETLFLAG+"^"+PUB_CNT.HITYPE+"^"+PUB_CNT.SSN.HOSPID
		var rtn=InsuLiquidationMx(0,PUB_CNT.SSN.USERID,PUB_CNT.HITYPE,ExpString);
		$.messager.progress("close");
	    if(rtn<0){
				$.messager.alert('����','����ϸ��ʧ�ܣ�');
				return;
			  }else{
				$.messager.alert('��ʾ','������ϸ���');
			  }
}
//ͬ��HISҽ����������
function SynHisDiv() 
{
	var ClrType=$('#clrType').combobox('getValue');
	if(ClrType == ""){
		$.messager.alert('��ʾ','���������Ϊ��');
		return;
	}
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	$.messager.progress({
		title: "��ʾ",
		text: '����ͬ��HISҽ�������������Ժ�....'
	});

	//ͬ������
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
			$.messager.alert('��ʾ','ͬ��HISҽ���������ݷ�������rtn='+rtn);
			return;	
		}else{
			 $.messager.alert('��ʾ','ͬ��HISҽ���������ݳɹ�:'+rtn,'info',function(){DivSumCreate_Click();});
			}
		DivHisQuery_click();
        DivCenterQuery_click();
	});
}
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
			
		},
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

function btnImportCenterDiv(){

	var DivSumDr = "",TrtMonth="";
	var trtMonth="";
	var BusiType="1";
	if(DivSumDr =="")
	{
		var encdate=getValueById("endate");
		if(encdate==""){$.messager.alert('��ʾ','�������ڲ���Ϊ��');return;}
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
		            $.messager.alert('��ʾ','������ϣ�');
		        }else{
					$.messager.alert('��ʾ','����ʧ��: ' + res);   
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

	
	/*if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ������˵ļ�¼��');
		return;
	}
	if(selectedRow.blFlag!="������"){
		$.messager.alert('��ʾ','�Ǵ�����״̬�������������ϸ��');
		return;
	}*/
	var DivSumDr = "",trtMonth="";
	var trtMonth=getValueById("endate");
	var BusiType="1";
    if(DivSumDr =="")
	{
		var encdate=getValueById("endate");
		if(encdate==""){$.messager.alert('��ʾ','�������ڲ���Ϊ��');return;}
		var trtMonth=(encdate.slice(0,7)).replace("-","");
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
	    if((file==null)||(file==undefined)) return;
	    $.messager.progress({
		title: "��ʾ",
		text: '���ڵ��������ҽ������....'
	   });
	    var form = new FormData();
	    form.append("FileStream", file); //��һ�������Ǻ�̨��ȡ������keyֵ
	    form.append("fileName", file.name);
	    $.ajax({
	        url:jsonQueryUrl+'INSU.MI.BL.DivMonstmtCtl'+SplCode+'ImportHisDivInfoFromCSV'+SplCode+DivSumDr+ArgSpl+PUB_CNT.SSN.USERID+ArgSpl+PUB_CNT.SSN.HOSPID+ArgSpl+BusiType+ArgSpl+trtMonth+ArgSpl+PUB_CNT.HITYPE,
	        type:'post',
	        data: form,
	        contentType: false,
	        processData: false,
	        success:function(res){
	            console.log(res);
	            if((res=="0")||(res=="\r\n0")){
		            $.messager.alert('��ʾ','������ϣ�');
		        }else{
					$.messager.alert('��ʾ','����ʧ��: ' + res);   
				}
				$.messager.progress("close");
				DivHisQuery_click();
				
	        }
	    })
	  },false);
	inputObj.click();
}
//����ҽ�������쳣(����)
function btnStrikeForInsu()
{
	var selectedRow = $('#CenterDivDetDg').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ��ҽ���쳣�ļ�¼��');
		return;
	}
	if(selectedRow.blHisDivDr>0){
		$.messager.alert('��ʾ','��ѡ���ƽ״̬Ϊ:��ļ�¼');
		return;
	}
	var rtncode=-1;
	var clrOptins=selectedRow.ClrOptins;
	var Rowid=selectedRow.Rowid;
	var djlsh=selectedRow.djlsh;
	//var hiType=$('#hiType').combobox('getValue');
	//var ClrType=$('#clrType').combobox('getValue');
	var hiType=selectedRow.HiType;
	if(hiType==""){hiType=$('#hiType').combobox('getValue');}
	var ClrType=selectedRow.ClrType;
	if(ClrType==""){ClrType=$('#clrType').combobox('getValue');}
	var ExpString="^^"+selectedRow.psnno+"^"+selectedRow.zylsh+"^"+selectedRow.InsuTotAmt+"^"+selectedRow.msgid+"^"+ClrType+"^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
	if((ClrType=="11")||(ClrType=="41")){
		//Handle,UserId,djlsh0,AdmSource,AdmReasonId,ExpString,CPPFlag)
		rtncode=InsuOPDivideCancleForInsu(0,PUB_CNT.SSN.USERID,djlsh,hiType,"",ExpString)
	}else{
		rtncode=InsuIPDivideCancleForInsu(0,PUB_CNT.SSN.USERID,djlsh,hiType,"",ExpString)
	}
	if(rtncode!="0") {
		$.messager.alert('��ʾ','����ʧ��: ' + rtncode);
	}else{
		$.messager.alert('��ʾ','������ϣ����ҽ����HIS��û���쳣�Ϳ����ٴζ�������');
		var blInfo="3^"+PUB_CNT.SSN.USERID;
		UpdCenterDivBlInfo(Rowid,blInfo) ;//�����쳣��������Ϣ DingSH 20210512
		DivCenterQuery_click();
	}
}
///����ҽ�����Ľ�����ˮ�������Ϣ
function UpdCenterDivBlInfo(rowid,blInfo){
	
	$.m({
		ClassName: "INSU.MI.DAO.CenterDivInfo",
		MethodName: "UpdCenterDivBlInfo",
		type: "GET",
		rowid: rowid,
		blInfo: blInfo
	}, function (rtn) {
       if (rtn.split("^")[0]>0) {$.messager.alert('��ʾ','�������');}
       else{{$.messager.alert('��ʾ','�����쳣'+rtn);}}
	});	
	
}


///����HISҽ��������ˮ�������Ϣ
function UpdHisDivBlInfo(rowid,blInfo){
	
	$.m({
		ClassName: "INSU.MI.DAO.HisDivInfo",
		MethodName: "UpdHisDivBlInfo",
		type: "GET",
		rowid: rowid,
		blInfo: blInfo
	}, function (rtn) {
       if (rtn.split("^")[0]>0) {$.messager.alert('��ʾ','�������');}
       else{{$.messager.alert('��ʾ','�����쳣'+rtn);}}
	});	
	
}

function btnStrikeForHis()
{
	var selectedRow = $('#HisDivDetDg').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','��ѡ��ҽ���쳣�ļ�¼��');
		return;
	}
	if(selectedRow.DivideDr==""){
		$.messager.alert('��ʾ','���ʵ�Ƿ��ǵ���HIS���ݣ�');
		 return;
	 }
	if(selectedRow.DivCenterDr >0){
		$.messager.alert('��ʾ','��ѡ���ƽ״̬Ϊ����ļ�¼');
		 return;
		}	
		
	var rtncode=-1;
	var clrOptins=selectedRow.ClrOptins;
	var Rowid=selectedRow.Rowid;
	var blHisDivDr="";
	var BillNo="";
	//selectedRow.psnno,selectedRow.zylsh,selectedRow.InsuTotAmt,selectedRow.djlsh

	var ExpString="^^"+selectedRow.psnno+"^"+selectedRow.zylsh+"^"+selectedRow.HisTotAmt+"^"+selectedRow.msgid+"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
	
	var hiType=$('#hiType').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	if((ClrType=="11")||(ClrType=="41")){
		
		rtncode=InsuOPDivideCancleForHis(0,PUB_CNT.SSN.USERID,selectedRow.DivideDr,hiType,"",ExpString,"")
	}else{
		var divstr=tkMakeServerCall("web.DHCINSUDivideCtl","GetDivById",selectedRow.DivideDr);
		if(divstr.length>10){
			BillNo=divstr.split("^")[3]
			if(BillNo=="") {$.messager.alert('��ʾ','δ�ҵ��˵��ţ�');return;}
		}
		rtncode=InsuIPDivideCancleForHis(0,PUB_CNT.SSN.USERID,BillNo,hiType,"",ExpString)
	}
	if(rtncode!="0") {
		$.messager.alert('��ʾ','����ʧ��: ' + rtncode); 
	}else{
		$.messager.alert('��ʾ','������ϣ����ҽ����HIS��û���쳣�Ϳ����ٴζ�������');
		var blInfo="3^"+PUB_CNT.SSN.USERID;
		UpdHisDivBlInfo(Rowid,blInfo) ;//�����쳣��������Ϣ DingSH 20210512
		DivHisQuery_click();
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

//����ҽ�����Ķ�����
function btnCenterDivEpot()
{
    var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx=$('#insutype').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	var ErrFlag=getValueById('errFlag')
	//var Options=$('#setlOptins').combobox('getValue');
	var refdSetlFlag=getValueById('refdSetlFlag');
	if(ClrType==""){
		$.messager.alert('ע��','���������Ϊ�գ�');
		return;
	}
	
	if(StDate==""||EndDate==""){
		$.messager.alert('ע��','�������ڲ���Ϊ�գ�');
		return;
	}
	if(hiType==""){
		$.messager.alert('ע��','ҽ�����Ͳ���Ϊ�գ�');
		return;
	}
	var ExcelName="CenterDiv"+getExcelFileName();
	$.messager.progress({
			   title: "��ʾ",
			   msg: '���ڵ���ҽ�����Ķ�����',
			   text: '������....'
		   });
	var rtn = tkMakeServerCall("websys.Query","ToExcel",ExcelName,"INSU.MI.DAO.CenterDivInfo","CenterDivQuery",StDate,EndDate,hiType,ClrType,Xzlx,"1",refdSetlFlag,ErrFlag,PUB_CNT.SSN.HOSPID,PUB_CNT.SSN.USERID,"","1");
	location.href = rtn ; 	
	setTimeout('$.messager.progress("close");', 3 * 1000);
	
}

//����ҽԺ��ҽ������
function btnHisDivEpot()
{
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var hiType=$('#hiType').combobox('getValue');
	var Xzlx=$('#insutype').combobox('getValue');
	var ClrType=$('#clrType').combobox('getValue');
	var Options=$('#setlOptins').combobox('getValue');
	var ErrFlag=getValueById('errFlag');
	var refdSetlFlag=getValueById('refdSetlFlag');
	if(ClrType==""){
		$.messager.alert('ע��','���������Ϊ�գ�');
		return;
	}
	if(StDate==""||EndDate==""){
		$.messager.alert('ע��','�������ڲ���Ϊ�գ�');
		return;
	}
	if(hiType==""){
		$.messager.alert('ע��','ҽ�����Ͳ���Ϊ�գ�');
		return;
	}
	var ExcelName="HisDiv"+getExcelFileName()
	$.messager.progress({
			   title: "��ʾ",
			   msg: '���ڵ���ҽԺ������',
			   text: '������....'
		   });
	var rtn = tkMakeServerCall("websys.Query","ToExcel",ExcelName,"INSU.MI.DAO.HisDivInfo","HisDivQuery",StDate,EndDate,hiType,ClrType,Xzlx,"1",refdSetlFlag,Options,ErrFlag,PUB_CNT.SSN.HOSPID,PUB_CNT.SSN.USERID,"","1");
	location.href = rtn ; 	
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
