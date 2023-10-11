/*
 * FileName:	dhcinsu.insupsninfo.js
 * User:		DingSH
 * Date:		2021-01-08
 * MainJS:      dhcinsu.insuservqry.js
 * Description: ҽ����Ա��Ϣ��ѯ
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
 
	// ҽ������
	init_PsnINSUType();
	init_PsnCertType();
	//click�¼�
	init_PsnClick();
	//��ʼ���α���Ϣdg	
	init_insudg(); 
	//��ʼ����Ա�����Ϣdg
	insu_IdenDg();
	//��ʼ���ۼ���Ϣdg
	init_cuminfodg();
	//init_Psnlayout();
	InitInsuplcAdmdvsLst();
	
});

/**
*��ʼ��click�¼�
*/		
function init_PsnClick()
{
	 //��ѯ
	 $("#btnPsnQry").click(PsnQry_Click);
	 $("#btnPsnClear").click(PsnClear_Click);
  
}

/**
*����
*/
function PsnClear_Click(){
	 GV.INSUTYPE= '';      //ҽ������
	 GV.PSNNO='';          //��Ա���
	 GV.INSUPLCADMDVS='';  //�α�ͳ����
	 GV.MDTRTID='';        //ҽ������ID
	 GV.SETLID='';         //ҽ������ID
	 $("#psnInfo").form("clear");
	 $("#insudg").datagrid({data:[]});
	 $("#cuminfodg").datagrid({data:[]});
	 
	}
/**
*��ѯ
*/	
function PsnQry_Click()
{
	
	var ExpStr="" //��ʽ����ϵ�绰^��ַ^ҽԺͬ��תԺ��־^תԺ����^תԺ����^תԺԭ��^תԺ���^��ʼ����^��������^����^ת��ҽԺ����ģ������^ת��ҽԺ����^��������^���ݿ����Ӵ�
	//ƾ������
	var psn_mdtrt_cert_type=getValueById('psn_mdtrt_cert_type');
	if(psn_mdtrt_cert_type == "")
	{
		$.messager.alert("��ܰ��ʾ","ƾ�����Ͳ���Ϊ��!", 'info');
		return ;
	}
	var psn_mdtrt_cert_no=getValueById('psn_mdtrt_cert_no');
	if((psn_mdtrt_cert_no== "")&&(psn_mdtrt_cert_type!="03"))
	{
		$.messager.alert("��ܰ��ʾ","ƾ�ݱ�Ų���Ϊ��!", 'info');
		return ;
	}
	//UserId, PaadmRowid, AdmReasonId,transId, amount, traceNo, cardNo, id ,ExpStr
	if (psn_mdtrt_cert_type=="03")
	{
		var rtn=InsuMedCardBill(GV.USERID,"","","04",0,"","","","^^^^^"); //DHCINSUPort.js
		if (rtn.split("^")[0]<0){$.messager.alert("��ܰ��ʾ","����ʧ��", 'error');return ;}
		var cardData = rtn.split("^")[1].split("|");
		//����ֵ��ʽ
		//102440280620011|52572233|F54706673|440223198109042217|��¸�|000000089477|440200811532|GDYB20201126|
		setValueById('psn_name',cardData[4]);              //��Ա����
		setValueById('psn_card_no',cardData[2]);           //ҽ������
		setValueById('psn_account',(+cardData[5]/100));    //ҽ�����
		setValueById('psn_certno',cardData[3]);            //ҽ�����
		setValueById('psn_mdtrt_cert_no',cardData[3]);     //ҽ�����
	}
	var outPutObj=getPersonInfo();
	if(!outPutObj){return ;}
	setValueById('psn_name',outPutObj.baseinfo.psn_name);                         //��Ա����
	setValueById('age',outPutObj.baseinfo.age);                                   //����
	setValueById('brdy',outPutObj.baseinfo.brdy);                                 //��������
	setValueById('gend',outPutObj.baseinfo.gend=="1"?"��":"Ů");                  //�Ա�
	setValueById('naty',outPutObj.baseinfo.naty);                                 //����
	setValueById('psnNo',outPutObj.baseinfo.psn_no);                              //ҽ�����
	GV.PSNNO=outPutObj.baseinfo.psn_no           
	GV.INSUPLCADMDVS =outPutObj.insuinfo[0].insuplc_admdvs;                        //�α�����
	setValueById('insuplc_admdvs',GV.INSUPLCADMDVS );                              //ҽ�����
	if (outPutObj.insuinfo.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ�ļ�¼!", 'info');return ;}  
	loadQryGrid("insudg",outPutObj.insuinfo)
	loadQryGrid("insuIdenDg",outPutObj.idetinfo) ///������Ա�����Ϣ LuJh 20230310
	getAdmExInfo();
	var outPutObj=getCumInfo();
	if(!outPutObj){return ;}
	if (outPutObj.cuminfo.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ���ۼƼ�¼!", 'info');return ;}
	loadQryGrid("cuminfodg",outPutObj.cuminfo)
}

///1101��Ա��Ϣ��ȡ
function getPersonInfo()
{
	 $("#insudg").datagrid({data:[]});
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('PsnINSUType')+"^"+"1101"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"mdtrt_cert_type","02");
	QryParams=AddQryParam(QryParams,"mdtrt_cert_no",getValueById('psn_mdtrt_cert_no'));
	QryParams=AddQryParam(QryParams,"card_sn","");
	QryParams=AddQryParam(QryParams,"begntime","");
	QryParams=AddQryParam(QryParams,"psn_cert_type","");
	QryParams=AddQryParam(QryParams,"certno","");
	QryParams=AddQryParam(QryParams,"psn_name","");
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
 * ��Ա�����Ϣdatagrid addBy LuJH 20230310
 */
function insu_IdenDg() {
	var dgColumns = [[
			{field:'psn_idet_type',title:'��Ա������',width:125},
			{field:'psn_type_lv',title:'��Ա���ȼ�',width:120},	
			{field:'memo',title:'��ע',width:100},
			{field:'begntime',title:'��ʼʱ��',width:120 },
			{field:'endtime',title:'����ʱ��',width:100}
		]];
	
	// ��ʼ����Ա�����ϢDataGrid
	$('#insuIdenDg').datagrid({
		fit:true,
		border:false,
		//striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		toolbar: [],
		columns: dgColumns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		}
	});
}

//���ݾ�����Ϣ
function getAdmExInfo(){
	$.m({ClassName:'web.DHCINSUAdmInfoCtl',
	      MethodName:'GetInAdmInfoExByInsuId',
	      InsuId:getValueById('psnNo'),
	      HisAdmType:"", 
	      ActFlag:"", 
	      HospDr:GV.HOSPDR
		},function(rtn){;
			  var dataAry=rtn.split("^")
			  //alert(rtn);
			  if (+dataAry[0]>0){
				  
				  setValueById('psn_inAdmDr',dataAry[0]);  
				  setValueById('psn_admDr',dataAry[1]);  
				  setValueById('psn_mdtrtId',dataAry[2]); 
				  GV.MDTRTID=dataAry[2];
				  setValueById('psn_admDate',dataAry[3]+" " +dataAry[4]);                            
				  setValueById('psn_admLoc',dataAry[5]);   
				  setValueById('psn_actFlag',dataAry[6]);                          
	              setValueById('psn_inDivDr',dataAry[7]);                              
				  setValueById('psn_DivFlag',dataAry[8]);     
				  setValueById('psn_DivDjlsh0',dataAry[9]);
				  GV.SETLID=dataAry[9];                       
				  }
			});
	}

//5206��Ա�ۼ���Ϣ
function getCumInfo(){
	
	 $("#cuminfodg").datagrid({data:[]});
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('PsnINSUType')+"^"+"5206"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('psnNo'));
	QryParams=AddQryParam(QryParams,"cum_ym","");
	QryParams=AddQryParam(QryParams,"insuplc_admdvs",getValueById("insuplc_admdvs"));
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
 * ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
 */
function init_PsnINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('PsnINSUType','DLLType',Options); 	
	$('#PsnINSUType').combobox({
		onSelect:function(rec){
			init_PsnCertType();
			GV.INSUTYPE=getValueById('PsnINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		}
	})	;
	
}

/*
 * ����ƾ֤����
 */
function init_PsnCertType(){
	var Options = {
		defaultFlag:'Y',
		editable:'Y',
		hospDr:GV.HOSPDR	
	}
	INSULoadDicData('psn_mdtrt_cert_type','mdtrt_cert_type' + getValueById('PsnINSUType'),Options); 	
}

/*
 * datagrid
 */
function init_insudg() {
	var dgColumns = [[
			{field:'balc',title:'���',width:75,hidden:true},
			{field:'insutype',title:'��������',width:150,formatter: function(value,row,index){
				var DicType="insutype"+getValueById('PsnINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'psn_insu_stas',title:'����״̬',width:100,formatter: function(value,row,index){
				return value=="1" ? "��":"��" ;
				}},
			{field:'psn_type',title:'��Ա���',width:120,formatter: function(value,row,index){
				var DicType="psn_type"+getValueById('PsnINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'cvlserv_flag',title:'����Ա��־',width:100,formatter: function(value,row,index){
				return value=="1" ? "��":"��" ;
				}},
			{field:'insuplc_admdvs',title:'�α�������',width:120,formatter: function(value,row,index){
				//var DicType="YAB003"+getValueById('PsnINSUType');
				var DicType="admdvs"+getValueById('PsnINSUType');	//upt HanZH 20230519
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'emp_name',title:'��λ����',width:140 },
			{field:'psn_idet_type',title:'��Ա������',width:120,formatter: function(value,row,index){
				var DicType="psn_idet_type"+getValueById('PsnINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'psn_type_lv',title:'��Ա���ȼ�',width:100},
			{field:'memo',title:'��ע',width:100},
			{field:'begntime',title:'��ʼʱ��',width:120 },
			{field:'endtime',title:'����ʱ��',width:100,hidden:true}
		]];

	// ��ʼ��DataGrid
	$('#insudg').datagrid({
		fit:true,
		border:false,
		//striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		toolbar: [],
		columns: dgColumns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		}
	});
	
}

function init_cuminfodg() {
	var dgColumns = [[
			{field:'insutype',title:'��������',width:150,formatter: function(value,row,index){
				var DicType="insutype"+getValueById('PsnINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'cum_ym',title:'�ۼ�����',width:100 },
			{field:'cum_type_code',title:'�ۼ����',width:200 ,formatter: function(value,row,index){
				var DicType="cum_type_code"+getValueById('PsnINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'cum',title:'�ۼ�ֵ',width:160},
			{field:'year',title:'���',width:100}
		]];

	// ��ʼ��DataGrid
	$('#cuminfodg').datagrid({
		fit:true,
		border:false,
		//striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		toolbar: [],
		columns: dgColumns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		}
	});
}
/**
*��ʼ��������ϼ�¼
*/
function InitInsuplcAdmdvsLst()
{
	
	$('#insuplc_admdvs').combogrid({    
	    panelWidth:450, 
	    method:'GET',
	    idField:'cCode',  
	    textField:'cDesc' ,  
	    delay: 500,
	    mode: 'remote',
	    method: 'GET',
	    columns:[[    
	        {field:'cCode',title:'��������',width:100},   
	        {field:'cDesc',title:'��������',width:160} 
	    ]] ,
	     onBeforeLoad: function(param) {
			if (typeof param.q == "undefined"){
				}
			if (($.trim(param.q).length >=1)) {
				 QryInsuplcAdmdvsLst();
			}
		},
	    
		onClickRow:function(rowIndex, rowData)
		{
			 
		}
  });  

}
/**
*��ѯ��¼
*/
function QryInsuplcAdmdvsLst()
{   
	 //var tURL=$URL+"?ClassName="+'web.INSUDicDataCom'+"&QueryName="+'QueryDic'+"&Type="+("YAB003"+getValueById('PsnINSUType'))+"&PYM="+getValueById('insuplc_admdvs')+"#HospDr="+GV.HOSPDR;
     var tURL=$URL+"?ClassName="+'web.INSUDicDataCom'+"&QueryName="+'QueryDic'+"&Type="+("admdvs"+getValueById('PsnINSUType'))+"&PYM="+getValueById('insuplc_admdvs')+"#HospDr="+GV.HOSPDR;
     $('#insuplc_admdvs').combogrid({url:tURL});
    
   
}
