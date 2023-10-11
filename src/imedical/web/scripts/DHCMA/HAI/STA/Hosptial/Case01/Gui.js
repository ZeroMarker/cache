
function InitCtlResultWin(){
	var obj = new Object();
	obj.btnClick="btnInfCase"
	Common_CreateMonth('SearchMonth');
	
	obj.girdInfList =$HUI.datagrid("#gridInfList",{
		fit: true,
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		singleSelect:false,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		nowrap:true,
		fitColumns: true,
		loadMsg:'���ݼ�����...',
		columns:[[
			{field:'ind',title:'���',width:145}, 
			{field:'LocDesc',title:'����',width:200},
			{field:'InfCount',title:'��Ⱦ����',width:200},
			{field:'InLocCount',title:'ͬ���ڿ�����',width:200},
			{field:'InfRatio',title:'��Ⱦ���η�����',width:200,
				formatter:function(value){
					return parseFloat(value).toFixed(2)+"%"
				}
			}
		]],
		onDblClickRow:function(rowIndex,rowData){	
		}
	});
	
	$("#redkw").keywords({
    	singleSelect:true,
   	 	labelCls:'red',
    	items:[
        	{text:'��Ⱦ����ͳ��ͼ',id:'keyInfCase',selected:true},
        	{text:'��Ⱦ���ͳ��ͼ',id:'keyInfDrug'},
        	{text:'��Ⱦ����ͳ�Ʊ�',id:'keyInfData'}
   		 ],
    	onClick:function(v){
	    	if (v.id=="keyInfCase"){
				$('#Case02').css('display','none');
				$('#Case01').css('display','block');
				obj.ShowEChart1();
			}else if (v.id=="keyInfDrug"){
				$('#Case02').css('display','none');
				$('#Case01').css('display','block');
				obj.ShowEChart2();
			}else if (v.id=="keyInfData"){
				$('#Case01').css('display','none');
				$('#Case02').css('display','block');
				obj.ShowTable1();
			}
	    }
	});
	InitCtlResultWinEvent(obj);
	obj.loadEvent(arguments)
	return obj;
}