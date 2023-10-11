var userid = session['LOGON.USERID'];
var CompName=session['LOGON.HOSPID'];
var startIndex = undefined;
var editIndex=undefined;
$(function(){//��ʼ��
    Init();
}); 

function Init(){
    MainColumns=[[ 
                {
	                field:'ck',
	                checkbox:true
	            }, 
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'CompName',title:'ҽ�Ƶ�λ',width:80,hidden: true},
                {field:'code',title:'����������',align:'left',width:140,editor: { type: 'text'}},
                {field:'name',title:'�����������',align:'left',width:140,editor: { type: 'text'}},
                {field:'isvalid',title:'�Ƿ���Ч',align:'left',width:150,hidden: true}

            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgDeptType",
            MethodName:"List",
            hospid : hospid, 
            sortField:  "",
            sortDir :    ""
        },
        fitColumns: false,//�й̶�
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        singleSelect:true,
        rownumbers:true,//�к�
        singleSelect: false, //ֻ����ѡ��һ��
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        columns:MainColumns,
        onClickRow: onClickRow,  //���û����һ�е�ʱ�򴥷�
        onLoadSuccess:function(data){
            
        },
        onClickCell: function(index,field,value){   //���û����һ����Ԫ���ʱ�򴥷�
            if ((field=="code")) {
                //$('#MainGrid').datagrid('selectRow', index);
                //var itemGrid = $('#MainGrid').datagrid('getSelected');
               
            }
        },
        striped : true,
        toolbar: '#tb'          
    }); 
    	//�ж��Ƿ�����༭
	function FYDEndEditing() {

		if (startIndex == undefined) {
			return true
		}
		if ($('#MainGrid').datagrid('validateRow', startIndex)) {
			var ed = $('#MainGrid').datagrid('getEditor', {
					index: startIndex,
					field: 'code'
				});
			$('#MainGrid').datagrid('endEdit', startIndex);
			startIndex = undefined;
			return true;
		} else {
			return false;
		}
	}   
    //����һ��
    var AddRow = function(row){
	
	    if (FYDEndEditing()) {
				$('#MainGrid').datagrid('appendRow', {
					rowid:'',
                    CompName:'',
                    code:'',
                    name:'',
                    isvalid:''
				});
			
				startIndex = $('#MainGrid').datagrid('getRows').length - 1;
				$('#MainGrid').datagrid('selectRow', startIndex).datagrid('beginEdit', startIndex);
		}
        
        
    }
    
   $("#AddBn").click(function(){
	     AddRow();
	  });
    //���һ��ʱ������
    function onClickRow(index){
        $('#MainGrid').datagrid('selectRow', index);  
        $('#MainGrid').datagrid("beginEdit", index);             
    }
    $("#DeleteBn").click(function(){
	    var grid=$('#MainGrid');
        var rows = $('#MainGrid').datagrid("getSelections");
        
        if (CheckDataBeforeDel(rows) == true) {
            del(grid,"herp.budg.hisui.udata.uBudgDeptType","Delete")
            //DFindBtn();
        } else {
            return;
        }
    });
    function CheckDataBeforeDel(rows) {
        if(!rows.length){
            $.messager.popover({msg: '��ѡ����Ҫɾ�������ݣ�',type:'info'});
            return false;
        }
        return true;
    };
     // ��ѯ����
     //sortField, sortDir, start, limit, hospid
    var DFindBtn= function()
    {
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgDeptType",
                MethodName:"List",
                hospid :    "", 
                sortField:  "",
                sortDir :    ""
            })
    }

    // �����ѯ��ť 
    $("#FindBn").click(DFindBtn);
    // �����ѯ��ť 
    $("#SaveBn").click(function(){
	     Save();
	  });
    var Save= function()
    {
	    var indexs = $('#MainGrid').datagrid('getEditingRowIndexs');
		if (indexs.length > 0) {
			for (i = 0; i < indexs.length; i++) {

				$('#MainGrid').datagrid("endEdit", indexs[i]);
			}
		}
	    
        var rows = $('#MainGrid').datagrid("getChanges");
        
        if(rows.length>0){
	       for(var i=0; i<rows.length; i++){
		      var row=rows[i]; 
		      var rowid= row.rowid;
		      
		      var code=row.code;
		      var desc=row.name;
		      //var CompName=row.CompName;
		      //����ǰ����Ϊ���е���֤
		      if (saveAllowBlankVaild($('#MainGrid'),row)){
			     $.messager.progress({
	                      title: '��ʾ',
	                      msg: '���ڱ��棬���Ժ򡭡�'
	             });
	             
		         $.m({
				     ClassName:'herp.budg.hisui.udata.uBudgDeptType',
					 MethodName:'Save',
					 rowId : rowid, 
					 code : code, 
					 name : desc,
					 CompName:CompName
				  },
				  function(Data){
					   if(Data==0){
							      $.messager.popover({
								      msg:'�����ɹ���',timeout: 3000,type:'info',showType: 'show',
								      style:{
									      "position":"absolute",
									      "z-index":"9999",
									      left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
									      top:10
									   }
									});
							          //$('#MainGrid').datagrid("reload");
							          DFindBtn();
							      	  $.messager.progress('close');
							      	 
						}else{
								   var message="����ʧ�ܣ�"
								   $.messager.popover({
								      msg:message,timeout: 3000,type:'info',showType: 'show',
								      style:{
									      "position":"absolute",
									      "z-index":"9999",
									      left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
									      top:10
									   }
									});
								    $.messager.progress('close');
						 }
					});
	             }
		      } 
	              
	        }
	        
    }
    //DFindBtn();
}