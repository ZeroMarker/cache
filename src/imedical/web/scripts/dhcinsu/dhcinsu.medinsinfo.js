/*
 * FileName:	dhcinsu.medinsinfo.js
 * Creator:		Chenyq
 * Date:		2021-12-30
 * MainJS:      dhcinsu.insuservqry.js
 * Description: 医药机构查询-1201
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
	// 医保类型
	init_medINSUType();
	//click事件
	init_regClick();
	//初始化医药机构查询记录dg	
	init_insudicdg(); 
	//医药机构名称回车查询事件
	$("#medinsName").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			MedQry_Click();
		}
	});
	
});

/**
*初始化click事件
*/		
function init_regClick()
{
	 //查询
	 $("#btnMedQry").click(MedQry_Click);
  
}
	
/**
*医药机构查询
*/	
function MedQry_Click()
{
	var ExpStr=""  
	//var medinsType=getValueById('medinsType');
	//if(medinsType=="")
	//{
	//	$.messager.alert("温馨提示","医疗服务机构类型不能为空!", 'info');
	//	return ;
	//}
	var SaveFlag=getValueById('SaveFlag')
    
	var outPutObj=getDicInfo();
	if(!outPutObj){return ;}
	if (outPutObj.medinsinfo.length==0){$.messager.alert("温馨提示","未查询到对应的医药机构记录!", 'info');return ;}
	loadQryGrid("insumeddg",outPutObj.medinsinfo);
	
	if (SaveFlag){ 
		SaveAll(outPutObj.medinsinfo);
	 }
}

/**
*医药机构数据保存
*/
function SaveAll(medinsinfo)
{
	var InAllStr=""
	var InStr="^2^00A^4199001000001^^^^^河南省人民医院^1^3^^^^^^^^^^^^^^^^^1^^^^^"
	var InStrAry=InStr.split("^")
	var j=0;
	//var len=medinsinfo.length
	
	for(var i=0;i<medinsinfo.length;i++){
		var obj=medinsinfo[i];
		InStrAry[1]= GV.HOSPDR;
	   	InStrAry[2]= getValueById('medINSUType');
	   	InStrAry[3]= obj.fixmedins_code;
	   	InStrAry[5]= obj.uscc;
	   	InStrAry[8]= obj.fixmedins_name;
	   	InStrAry[9]= obj.fixmedins_type;
	   	InStrAry[10]= obj.hosp_lv;
	   	InStrAry[26]= GV.USERID;   //经办人Id 
	   	var tmpInStr=InStrAry.join("^");
	   	j=j+1;
	   	if (InAllStr=="") {InAllStr=tmpInStr;}
		else{
			InAllStr=InAllStr+"$#$"+tmpInStr;
			}
			
		if(j==50){
			//tk()
			$m({
				ClassName:"INSU.MI.BL.FixmedinsCtl",
				MethodName:"SaveALL",
				InAllStr:InAllStr,
				HospDr:GV.HOSPDR,
				},false);
			j=0;
			}	
		if((j<50)&&(i==medinsinfo.length-1)){
			
			$m({
				ClassName:"INSU.MI.BL.FixmedinsCtl",
				MethodName:"SaveALL",
				InAllStr:InAllStr,
				HospDr:GV.HOSPDR,
			},function(rtn){
				if(rtn.split("^")[0]<0){
					$.messager.alert('提示',"医药机构数据保存失败："+rtn);
				}else{
			   		$.messager.alert('提示','医药机构数据保存成功');
				}
	  			$.messager.progress("close");
			});
			
			}
			
		}
	
}

///医药机构查询-1201
function getDicInfo()
{
	
	//数据库连接串
	var connURL=""
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('medINSUType')+"^"+"1201"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"fixmedins_type",getValueById('medinsType'));	
	QryParams=AddQryParam(QryParams,"fixmedins_name",getValueById('medinsName'));
	QryParams=AddQryParam(QryParams,"fixmedins_code",getValueById('medinsCode'));
	QryParams=AddQryParam(QryParams,"insuplc_admdvs",GV.INSUPLCADMDVS);
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
 * datagrid
 */
function init_insudicdg() {
	var dgColumns = [[
			{field:'fixmedins_type',title:'定点医疗服务机构类型',width:240,formatter: function(value,row,index){
				var DicType="fixmedins_type"+getValueById('medINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'fixmedins_code',title:'定点医药机构编号',width:200},
			{field:'fixmedins_name',title:'定点医药机构名称',width:336},	
			{field:'uscc',title:'统一社会信用代码',width:220},	
			{field:'hosp_lv',title:'医院等级',width:220,formatter: function(value,row,index){
				var DicType="hosp_lv"+getValueById('medINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}}	
		]];

	// 初始化DataGrid
	$('#insumeddg').datagrid({
		fit:true,
		border:false,
		data:[],
		//striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		}
	});
}

/*
 * 医保类型 和医保类型有关的 下拉框需要在这重新加载
 */
function init_medINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('medINSUType','DLLType',Options); 	
	$('#medINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('medINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
			INSULoadDicData('medinsType','fixmedins_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR}); // 医疗服务机构类型
		}
 
	})	;
	
}






