
function createRisWin(callBack){
	try{
		if($('#RisWin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
		$('body').append('<div id="RisWin"></div>');
		$('#RisWin').append('<div id="Ris"></div>');
		$('#Ris').datagrid({
		    url:'dhcapp.broker.csp',
		    fit:true,
			rownumbers:true,
			pageSize:100,        // ÿҳ��ʾ�ļ�¼����
			pageList:[100,200],   // ��������ÿҳ��¼�������б�
			loadMsg: $g('���ڼ�����Ϣ...'),
			pagination:true,
			nowrap:false,
			queryParams:{
	     		ClassName: 'PHA.CPW.Com.OutInterfance',
	     		MethodName: 'GetRisReport',
				EpisodeID: AdmDr
			},
			toolbar: [{
				text: $g('����'),
				iconCls: 'icon-ok',
				handler: function(){
					var dataArr = $('#Ris').datagrid("getChecked");
					var text = "";
					$.each(dataArr, function(key, val){
						text = text + val.StrOrderName +":"+ val.ResultDescEx +";  ";
					})
					if(text!=""){
					callBack(text);
					}
					$('#RisWin').window('close');
				}
			},'-',{
				text:$g('�ر�'),
				iconCls: 'icon-cancel',
				handler: function(){$('#RisWin').window('close');}
			}],
		    columns:[[
		    	{field:'check',checkbox:true},	
		    	{ field: 'DepLocDesc',align: 'center', title: $g('�������')},
    	        { field: 'No',align: 'center', title: $g('���뵥��')},
				{ field: 'StudyNo',align: 'center', title: $g('����')},
				{ field: 'StrOrderName',align: 'center', title: $g('�������')},
				{ field: 'strOrderDateDesc',align: 'center', title: $g('��������')},
				{ field: 'ItemStatus',align: 'center', title: $g('���״̬')},
				{ field: 'RecLocName',align: 'center', title: $g('������')},
				{ field: 'ExamDescEx',align: 'center', title: $g('�������')},
				{ field: 'ResultDescEx',align: 'center', title: $g('�����')},
				{ field: 'IsCVR',align: 'center', title: $g('Σ��ֵ����')},
				{ field: 'IsIll',align: 'center', title: $g('�Ƿ�����'),
					formatter:function(value,row,index){ 
						if (value=='Y'){return $g("��");} 
						else {return $g("��");}
					}}, 
		    
				    ]],
		    onDblClickRow: function(rowIndex, rowData){
			    var text = rowData.StrOrderName +":"+ rowData.ResultDescEx
			    callBack(text);
			}
		    
		});
		$('#RisWin').window({
			title:$g('����б�'),    
			collapsible:true,
			border:true,
			closed:"true",
			width:1050,
			height:500,
			minimizable:false,						
			onClose:function(){
				$('#RisWin').remove();  
			}
		}); 
		$('#RisWin').window('open');

	}catch(e){
		alert(e.message)
		}
}