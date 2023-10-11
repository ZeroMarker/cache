/*
 * FileName:	dhcinsu.medinsinfo.js
 * Creator:		Chenyq
 * Date:		2021-12-30
 * MainJS:      dhcinsu.insuservqry.js
 * Description: ҽҩ������ѯ-1201
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
	// ҽ������
	init_medINSUType();
	//click�¼�
	init_regClick();
	//��ʼ��ҽҩ������ѯ��¼dg	
	init_insudicdg(); 
	//ҽҩ�������ƻس���ѯ�¼�
	$("#medinsName").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			MedQry_Click();
		}
	});
	
});

/**
*��ʼ��click�¼�
*/		
function init_regClick()
{
	 //��ѯ
	 $("#btnMedQry").click(MedQry_Click);
  
}
	
/**
*ҽҩ������ѯ
*/	
function MedQry_Click()
{
	var ExpStr=""  
	//var medinsType=getValueById('medinsType');
	//if(medinsType=="")
	//{
	//	$.messager.alert("��ܰ��ʾ","ҽ�Ʒ���������Ͳ���Ϊ��!", 'info');
	//	return ;
	//}
	var SaveFlag=getValueById('SaveFlag')
    
	var outPutObj=getDicInfo();
	if(!outPutObj){return ;}
	if (outPutObj.medinsinfo.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ��ҽҩ������¼!", 'info');return ;}
	loadQryGrid("insumeddg",outPutObj.medinsinfo);
	
	if (SaveFlag){ 
		SaveAll(outPutObj.medinsinfo);
	 }
}

/**
*ҽҩ�������ݱ���
*/
function SaveAll(medinsinfo)
{
	var InAllStr=""
	var InStr="^2^00A^4199001000001^^^^^����ʡ����ҽԺ^1^3^^^^^^^^^^^^^^^^^1^^^^^"
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
	   	InStrAry[26]= GV.USERID;   //������Id 
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
					$.messager.alert('��ʾ',"ҽҩ�������ݱ���ʧ�ܣ�"+rtn);
				}else{
			   		$.messager.alert('��ʾ','ҽҩ�������ݱ���ɹ�');
				}
	  			$.messager.progress("close");
			});
			
			}
			
		}
	
}

///ҽҩ������ѯ-1201
function getDicInfo()
{
	
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
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
		$.messager.alert("��ʾ","��ѯʧ��!rtn="+rtn, 'error');
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
			{field:'fixmedins_type',title:'����ҽ�Ʒ����������',width:240,formatter: function(value,row,index){
				var DicType="fixmedins_type"+getValueById('medINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'fixmedins_code',title:'����ҽҩ�������',width:200},
			{field:'fixmedins_name',title:'����ҽҩ��������',width:336},	
			{field:'uscc',title:'ͳһ������ô���',width:220},	
			{field:'hosp_lv',title:'ҽԺ�ȼ�',width:220,formatter: function(value,row,index){
				var DicType="hosp_lv"+getValueById('medINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}}	
		]];

	// ��ʼ��DataGrid
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
 * ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
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
			INSULoadDicData('medinsType','fixmedins_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR}); // ҽ�Ʒ����������
		}
 
	})	;
	
}






