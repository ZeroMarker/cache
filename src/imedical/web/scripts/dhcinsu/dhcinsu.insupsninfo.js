/*
 * FileName:	dhcinsu.insupsninfo.js
 * User:		DingSH
 * Date:		2021-01-08
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 医保人员信息查询
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
 
	// 医保类型
	init_PsnINSUType();
	init_PsnCertType();
	//click事件
	init_PsnClick();
	//初始化参保信息dg	
	init_insudg(); 
	//初始化人员身份信息dg
	insu_IdenDg();
	//初始化累计信息dg
	init_cuminfodg();
	//init_Psnlayout();
	InitInsuplcAdmdvsLst();
	
});

/**
*初始化click事件
*/		
function init_PsnClick()
{
	 //查询
	 $("#btnPsnQry").click(PsnQry_Click);
	 $("#btnPsnClear").click(PsnClear_Click);
  
}

/**
*清屏
*/
function PsnClear_Click(){
	 GV.INSUTYPE= '';      //医保类型
	 GV.PSNNO='';          //人员编号
	 GV.INSUPLCADMDVS='';  //参保统筹区
	 GV.MDTRTID='';        //医保就诊ID
	 GV.SETLID='';         //医保结算ID
	 $("#psnInfo").form("clear");
	 $("#insudg").datagrid({data:[]});
	 $("#cuminfodg").datagrid({data:[]});
	 
	}
/**
*查询
*/	
function PsnQry_Click()
{
	
	var ExpStr="" //格式：联系电话^地址^医院同意转院标志^转院类型^转院日期^转院原因^转院意见^开始日期^结束日期^类型^转往医院名字模糊搜索^转往医院编码^病情描述^数据库连接串
	//凭据类型
	var psn_mdtrt_cert_type=getValueById('psn_mdtrt_cert_type');
	if(psn_mdtrt_cert_type == "")
	{
		$.messager.alert("温馨提示","凭据类型不能为空!", 'info');
		return ;
	}
	var psn_mdtrt_cert_no=getValueById('psn_mdtrt_cert_no');
	if((psn_mdtrt_cert_no== "")&&(psn_mdtrt_cert_type!="03"))
	{
		$.messager.alert("温馨提示","凭据编号不能为空!", 'info');
		return ;
	}
	//UserId, PaadmRowid, AdmReasonId,transId, amount, traceNo, cardNo, id ,ExpStr
	if (psn_mdtrt_cert_type=="03")
	{
		var rtn=InsuMedCardBill(GV.USERID,"","","04",0,"","","","^^^^^"); //DHCINSUPort.js
		if (rtn.split("^")[0]<0){$.messager.alert("温馨提示","读卡失败", 'error');return ;}
		var cardData = rtn.split("^")[1].split("|");
		//返回值格式
		//102440280620011|52572233|F54706673|440223198109042217|朱德福|000000089477|440200811532|GDYB20201126|
		setValueById('psn_name',cardData[4]);              //人员姓名
		setValueById('psn_card_no',cardData[2]);           //医保卡号
		setValueById('psn_account',(+cardData[5]/100));    //医保余额
		setValueById('psn_certno',cardData[3]);            //医保编号
		setValueById('psn_mdtrt_cert_no',cardData[3]);     //医保编号
	}
	var outPutObj=getPersonInfo();
	if(!outPutObj){return ;}
	setValueById('psn_name',outPutObj.baseinfo.psn_name);                         //人员姓名
	setValueById('age',outPutObj.baseinfo.age);                                   //年龄
	setValueById('brdy',outPutObj.baseinfo.brdy);                                 //出生日期
	setValueById('gend',outPutObj.baseinfo.gend=="1"?"男":"女");                  //性别
	setValueById('naty',outPutObj.baseinfo.naty);                                 //民族
	setValueById('psnNo',outPutObj.baseinfo.psn_no);                              //医保编号
	GV.PSNNO=outPutObj.baseinfo.psn_no           
	GV.INSUPLCADMDVS =outPutObj.insuinfo[0].insuplc_admdvs;                        //参保地区
	setValueById('insuplc_admdvs',GV.INSUPLCADMDVS );                              //医保编号
	if (outPutObj.insuinfo.length==0){$.messager.alert("温馨提示","未查询到对应的记录!", 'info');return ;}  
	loadQryGrid("insudg",outPutObj.insuinfo)
	loadQryGrid("insuIdenDg",outPutObj.idetinfo) ///加载人员身份信息 LuJh 20230310
	getAdmExInfo();
	var outPutObj=getCumInfo();
	if(!outPutObj){return ;}
	if (outPutObj.cuminfo.length==0){$.messager.alert("温馨提示","未查询到对应的累计记录!", 'info');return ;}
	loadQryGrid("cuminfodg",outPutObj.cuminfo)
}

///1101人员信息获取
function getPersonInfo()
{
	 $("#insudg").datagrid({data:[]});
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
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
		$.messager.alert("提示","查询失败!rtn="+rtn, 'error');
		return ;
	}
	 var outPutObj=JSON.parse(rtn.split("^")[1]);
	 
	return outPutObj;
}
/*
 * 人员身份信息datagrid addBy LuJH 20230310
 */
function insu_IdenDg() {
	var dgColumns = [[
			{field:'psn_idet_type',title:'人员身份类别',width:125},
			{field:'psn_type_lv',title:'人员类别等级',width:120},	
			{field:'memo',title:'备注',width:100},
			{field:'begntime',title:'开始时间',width:120 },
			{field:'endtime',title:'结束时间',width:100}
		]];
	
	// 初始化人员身份信息DataGrid
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

//根据就诊信息
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

//5206人员累计信息
function getCumInfo(){
	
	 $("#cuminfodg").datagrid({data:[]});
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
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
		$.messager.alert("提示","查询失败!rtn="+rtn, 'error');
		return ;
	}
	 var outPutObj=JSON.parse(rtn.split("^")[1]);
	return outPutObj;
	}

/*
 * 医保类型 和医保类型有关的 下拉框需要在这重新加载
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
 * 就诊凭证类型
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
			{field:'balc',title:'余额',width:75,hidden:true},
			{field:'insutype',title:'险种类型',width:150,formatter: function(value,row,index){
				var DicType="insutype"+getValueById('PsnINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'psn_insu_stas',title:'险种状态',width:100,formatter: function(value,row,index){
				return value=="1" ? "是":"否" ;
				}},
			{field:'psn_type',title:'人员类别',width:120,formatter: function(value,row,index){
				var DicType="psn_type"+getValueById('PsnINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'cvlserv_flag',title:'公务员标志',width:100,formatter: function(value,row,index){
				return value=="1" ? "是":"否" ;
				}},
			{field:'insuplc_admdvs',title:'参保地区划',width:120,formatter: function(value,row,index){
				//var DicType="YAB003"+getValueById('PsnINSUType');
				var DicType="admdvs"+getValueById('PsnINSUType');	//upt HanZH 20230519
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'emp_name',title:'单位名称',width:140 },
			{field:'psn_idet_type',title:'人员身份类别',width:120,formatter: function(value,row,index){
				var DicType="psn_idet_type"+getValueById('PsnINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'psn_type_lv',title:'人员类别等级',width:100},
			{field:'memo',title:'备注',width:100},
			{field:'begntime',title:'开始时间',width:120 },
			{field:'endtime',title:'结束时间',width:100,hidden:true}
		]];

	// 初始化DataGrid
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
			{field:'insutype',title:'险种类型',width:150,formatter: function(value,row,index){
				var DicType="insutype"+getValueById('PsnINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'cum_ym',title:'累计年月',width:100 },
			{field:'cum_type_code',title:'累计类别',width:200 ,formatter: function(value,row,index){
				var DicType="cum_type_code"+getValueById('PsnINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'cum',title:'累计值',width:160},
			{field:'year',title:'年度',width:100}
		]];

	// 初始化DataGrid
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
*初始化就诊诊断记录
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
	        {field:'cCode',title:'区划代码',width:100},   
	        {field:'cDesc',title:'区划名称',width:160} 
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
*查询记录
*/
function QryInsuplcAdmdvsLst()
{   
	 //var tURL=$URL+"?ClassName="+'web.INSUDicDataCom'+"&QueryName="+'QueryDic'+"&Type="+("YAB003"+getValueById('PsnINSUType'))+"&PYM="+getValueById('insuplc_admdvs')+"#HospDr="+GV.HOSPDR;
     var tURL=$URL+"?ClassName="+'web.INSUDicDataCom'+"&QueryName="+'QueryDic'+"&Type="+("admdvs"+getValueById('PsnINSUType'))+"&PYM="+getValueById('insuplc_admdvs')+"#HospDr="+GV.HOSPDR;
     $('#insuplc_admdvs').combogrid({url:tURL});
    
   
}
