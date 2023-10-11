var hospid = session['LOGON.HOSPID'];

$(function(){//��ʼ��
    Initmain();
}); 

function Initmain(){
	
	//���������
		var yearBoxobj = $HUI.combobox("#yearBox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
			mode: 'remote',
			delay: 200,
			valueField: 'year',
			textField: 'year',
			onBeforeLoad: function (param) {
				param.str = param.q,
				param.flag = ""
				},
			onSelect:function(rec){
				$('#itemSearchGrid').datagrid('load', {
					ClassName: 'herp.budg.hisui.udata.uCtrlItemBudgSearch',
					MethodName: 'ctrlBudgList', 
					year:$("#yearBox").combobox("getValue"),
					deptid:"",
					})
				}
		});
    //����������
    var deptBoxobj = $HUI.combobox("#deptBox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept&ResultSetType=array",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.str = param.q,
				param.flag = ""
			},
			onSelect:function(rec){
				$('#itemSearchGrid').datagrid('load', {
					ClassName: 'herp.budg.hisui.udata.uCtrlItemBudgSearch',
					MethodName: 'ctrlBudgList', 
					year:$("#yearBox").combobox("getValue"),
					deptid:$("#deptBox").combobox("getValue"),
					})
				}
		});
		
	var GridColumn = [[ {
				field: 'year',
				title: '���',
				width: 120,
			}, {
				field: 'deptname',
				title: '����',
				width: 120,
			}, {
				field: 'sumyear',
				title: '�������������Ԥ��',
				width: 180,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Jan',
				title: 'һ��',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Feb',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Mar',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Apr',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'May',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'June',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'July',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Aug',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Sept',
				title: '����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Oct',
				title: 'ʮ��',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Nov',
				title: 'ʮһ��',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}, {
				field: 'Dec',
				title: 'ʮ����',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat
			}			

		]]
		var itemSearchGridObj = $HUI.datagrid('#itemSearchGrid', {
			region: 'center',
			fit: true,
			url: $URL,
			columns: GridColumn,
			queryParams:{
				ClassName: 'herp.budg.hisui.udata.uCtrlItemBudgSearch',
				MethodName: 'ctrlBudgList', 
				year:"",
				deptid:"",
			},
			singleSelect: true, 
			rownumbers: true, //�к�
			pagination: true, //��ҳ
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100]
		});
		
		
	//��ѯ����¼�
	$("#FindBtn").click(function(){
		if($("#deptBox").combobox("getValue")){
			var deptder=$("#deptBox").combobox("getValue")
		}else{
			var deptder=""
			}
           
           itemSearchGridObj.load({
                ClassName: 'herp.budg.hisui.udata.uCtrlItemBudgSearch',
				MethodName: 'ctrlBudgList', 
				year:$("#yearBox").combobox("getValue"),
				deptid:deptder,
            })});

		
		
		
}