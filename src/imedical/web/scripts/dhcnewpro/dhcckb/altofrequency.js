var param = "";
var agree=0;
$(document).ready(function() {
			 initParams();
			 initDetailGrid();
			 initCombobox();
			 initButton();
})

//��ȡ����
function initParams()
{
		param = getParam("params");
}

//��ť��
function initButton()
{
	$('#find').bind("click",findPres);
	$('#reset').bind("click",resetPres);
}

//��ѯ��ť
function findPres()
{
	initDetailGrid(); 
}

//���ð�ť
function resetPres()
{
	$HUI.combobox("#sign").setValue("");
	initDetailGrid();
}

//����Ŀ����������
function initCombobox(){
	 
	 $HUI.combobox("#sign",{
				url: $URL+"?ClassName=web.DHCCKBAltoFreQuery&MethodName=QueryHospList&params="+param,
				valueField:'value',
				textField:'text',
				multiple:true,
				rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
				selectOnNavigation:false,
				panelHeight:"auto",
				editable:false,
				mode:'remote',
			 	onAllSelectClick:function(){
				 if(agree==0){
		    		agree=1;
				 }else{
					 agree=0;
				 }
	   }
	});
}


//���ؽ������
function initDetailGrid(){
	
	var HospList=$HUI.combobox("#sign").getValues()
	// ����columns	
	var columns=[];
	runClassMethod("web.DHCCKBAltoFreQuery","GetColumns",{'HospList':HospList.toString(),'agree':agree},function(jsonString){
		var jsonObject = jsonString;
		var ret = jsonObject.ret;
		var pid = jsonObject.pid;
		columns.push(jsonObject.columns);
	
	///  ����datagrid
	var option = {
		fitColumn:true,
		rownumbers : true,
		singleSelect : true,
		remoteSort:false,
		pageSize : [30],
		pageList : [30,60,90],
	};
	var params=param+"^"+encodeURI(HospList);
	var uniturl = $URL+"?ClassName=web.DHCCKBAltoFreQuery&MethodName=QueryRuleCat&params="+params;
	new ListComponent('addgrid', columns, uniturl, option).Init();
},'json','false')

}
