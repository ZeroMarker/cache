var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
var startIndex = undefined;
var editIndex=undefined;
$(function(){//��ʼ��
    Init();
}); 


function Init(){
	
	///str, hospid, userdr, flag = "", checkflag = ""
	var UserBox = {
		type:'combobox',
        options:{
            valueField:'rowid',
            textField:'name',
            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
            delay:200,
            onBeforeLoad:function(param){
					 param.hospid = hospid;
					 //param.userdr = userid;
					 param.str    = param.q;
					 param.flag    = "1";
			}
         }
	};
    MainColumns=[[ 
                {
	                field:'ck',
	                checkbox:true
	            }, 
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'CompName',title:'ҽ�Ƶ�λ',width:80,hidden: true},
                {field:'user',title:'��Ա����',align:'left',width:180,
                   formatter: CommonFormatter(UserBox,'user','userdr'),
                   editor:UserBox
                },
                {field:'atnumber',title:'�˺�',align:'left',width:250,editor: { type: 'text'}},
                {field:'openbank',title:'������',align:'left',width:250,editor: { type: 'text'}}

            ]];
            //sortField, sortDir, hospid, userdr, atnumber, user
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgBankInformationPreserve",
            MethodName:"List",
            hospid : hospid, 
            sortField:  "",
            sortDir :    "",
            userdr:"",
            atnumber:"",
            user:""
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
           
        },
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
            del(grid,"herp.budg.hisui.udata.uBudgBankInformationPreserve","Delete")
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
		      var user=row.user;
		      var atnumber=row.atnumber;
		      var openbank=row.openbank;
		      var CompName=row.CompName;
		      CompName=hospid;
		      //����ǰ����Ϊ���е���֤
		      if (saveAllowBlankVaild($('#MainGrid'),row)){
			     $.messager.progress({
	                      title: '��ʾ',
	                      msg: '���ڱ��棬���Ժ򡭡�'
	             });
	             //rowId, CompName, userdr, atnumber, openbank
		         $.m({
				     ClassName:'herp.budg.hisui.udata.uBudgBankInformationPreserve',
					 MethodName:'Save',
					 rowId : rowid, 
					 userdr : user, 
					 atnumber : atnumber,
					 openbank : openbank,
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
							          $('#MainGrid').datagrid("reload");
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