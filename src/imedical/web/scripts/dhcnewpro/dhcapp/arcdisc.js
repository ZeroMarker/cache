var arc="";


$(function(){
//��������һ���س��¼�
$('#params').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //queryAdrPatImpoInfo(this.id+"^"+$('#'+this.id).val()); //���ò�ѯ
           commonQuery(); //���ò�ѯ           
        }
    });

// ��ѯ��ť�󶨵����¼�
$('#find').bind('click',function(event){
         commonQuery(); //���ò�ѯ
    })
    
//���ð�ť�󶨵����¼�
$('#reset').bind('click',function(event){
		$('#params').val("");
		arc="";         //  qunianpeng  2016-07-15
		commonQuery(); //���ò�ѯ
	})
    
});
//��ѯ
function commonQuery(){
	var params=$('#params').val();
	$('#datagrid').datagrid('load',{params:params})
	}
    
function onClickRow(index,row){
	arc=row.arcimid;
	$('#discdatagrid').datagrid('load',{pointer:row.arcimid});
}


function addRow(){
	
	if(arc==""){
		$.messager.alert('��ʾ','����ѡ������Ŀ')
		return
	}
	// sufan ����˫��ʱ���رգ��ٵ����ӣ����ɱ༭
	var e = $("#discdatagrid").datagrid('getColumnOption', 'PartNum');
	e.editor = {type:'numberbox',options:{required:true,min:0}};
	var e = $("#discdatagrid").datagrid('getColumnOption', 'Discount');
	e.editor = {type:'numberbox',options:{required:true,min:0,precision:4,max:1}};
	var e = $("#discdatagrid").datagrid('getColumnOption', 'StartDate');
	e.editor = {type:'datebox',options:{required:true}};
	var e = $("#discdatagrid").datagrid('getColumnOption', 'OutFlag');
	e.editor = {type:'combobox',options:{
										valueField:'value',
										textField:'text',
										url:'dhcapp.broker.csp?ClassName=web.DHCAPPArcDisc&MethodName=listOutFlag',
										required:true}
									};
	commonAddRow({'datagrid':'#discdatagrid',value:{'ADArcDr':arc,'OutFlag':0,'Discount':1,'StartDate':new Date().Format("yyyy-MM-dd")}})
}

/// sufan 2017-04-13  ����ʱ�����ظ����ͻ���ݣ�������ʾ
function save()
{
	if(editIndex>="0"){
		$("#discdatagrid").datagrid('endEdit', editIndex);
	}
	var rowsData = $("#discdatagrid").datagrid('getChanges');
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var tmp=rowsData[i].ID +"^"+ arc +"^"+ rowsData[i].PartNum +"^"+ rowsData[i].Discount +"^"+ rowsData[i].StartDate +"^"+ rowsData[i].EndDate +"^"+  rowsData[i].OutFlag;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//����ǰ�ж��Ƿ������ʾ
	runClassMethod("web.DHCAPPArcDisc","PromptData",{"params":params},function(String){
		if(String==0)
		{
			savedisc();  ///���ñ��溯��
		}else
		{
			var  Tmpstr=String.split("&");
			var TempData=Tmpstr[0].split("!")
				if (TempData[1] == "-3"){
					$.messager.confirm("��ʾ", "�ô��۲�λ�Ѵ��ڣ���ȷ������������", function (res) {//��ʾ�Ƿ�ɾ��
					if (res)
					 {
							savedisc(); ///���ñ��溯��
						}
					$('#discdatagrid').datagrid('reload')
				});
			}
		 }
	},"text",false);
}	
function savedisc(){
		saveByDataGrid("web.DHCAPPArcDisc","save","#discdatagrid",function(data){
		if(data==0){
			$.messager.alert('��ʾ','����ɹ�')
		}else if(data==-11){
			$.messager.alert('��ʾ','��ʼʱ����ڽ���ʱ��')
		}else if(data==-101){
			$.messager.alert('��ʾ','ǰ�沿λ�Ĵ���ϵ�����ܵ��ں��沿λ�Ĵ���ϵ��,���ʵ!')
		}else{
			$.messager.alert('��ʾ','����ʧ��:'+data)
		}
		$('#discdatagrid').datagrid('reload')
	})
}

function onClickRowDisc(index,row){
	// sufan  2017-03-10  ˫��ʱ���رձ༭
	var e = $("#discdatagrid").datagrid('getColumnOption', 'PartNum');
	e.editor = {};
    var e = $("#discdatagrid").datagrid('getColumnOption', 'Discount');
	e.editor = {};
	var e = $("#discdatagrid").datagrid('getColumnOption', 'StartDate');
	e.editor = {};
	var e = $("#discdatagrid").datagrid('getColumnOption', 'OutFlag');
	e.editor = {};
	CommonRowClick(index,row,"#discdatagrid");
}