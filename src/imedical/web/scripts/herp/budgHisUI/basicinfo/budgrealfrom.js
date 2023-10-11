var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
var startIndex = undefined;
var editIndex=undefined;
$(function(){//初始化
    Init();
}); 

function Init(){
    MainColumns=[[ 
                {
	                field:'ck',
	                checkbox:true
	            }, 
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'CompName',title:'医疗单位',width:80,hidden: true},
                {field:'code',title:'编码',align:'center',width:140,editor: { type: 'text'}},
                {field:'name',title:'名称',align:'left',width:140,editor: { type: 'text'}},
                

            ]];
            //hospid, searchField, searchValue, sortField, sortDir
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgRealFrom",
            MethodName:"List",
            hospid : hospid, 
            searchField:"",
            sortField:  ""
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        singleSelect:true,
        rownumbers:true,//行号
        singleSelect: false, //只允许选中一行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onClickRow: onClickRow,  //在用户点击一行的时候触发
        onLoadSuccess:function(data){
            
        },
        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发
            if ((field=="code")) {
                //$('#MainGrid').datagrid('selectRow', index);
                //var itemGrid = $('#MainGrid').datagrid('getSelected');
               
            }
        },
        striped : true,
        toolbar: '#tb'          
    }); 
    	//判断是否结束编辑
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
    //增加一行
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
    //点击一行时触发。
    function onClickRow(index){
        $('#MainGrid').datagrid('selectRow', index);  
        $('#MainGrid').datagrid("beginEdit", index);             
    }
    $("#DeleteBn").click(function(){
	    var grid=$('#MainGrid');
        var rows = $('#MainGrid').datagrid("getSelections");
        
        if (CheckDataBeforeDel(rows) == true) {
            del(grid,"herp.budg.hisui.udata.uBudgRealFrom","Delete")
            //DFindBtn();
        } else {
            return;
        }
    });
    function CheckDataBeforeDel(rows) {
        if(!rows.length){
            $.messager.popover({msg: '请选中需要删除的数据！',type:'info'});
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
		      
		      var code=row.code;
		      var desc=row.name;
		      var CompName=row.CompName;
		      CompName=hospid;
		      //保存前不能为空列的验证
		      if (saveAllowBlankVaild($('#MainGrid'),row)){
			     $.messager.progress({
	                      title: '提示',
	                      msg: '正在保存，请稍候……'
	             });
	             
		         $.m({
				     ClassName:'herp.budg.hisui.udata.uBudgRealFrom',
					 MethodName:'Save',
					 rowid : rowid, 
					 code : code, 
					 name : desc,
					 CompName:CompName
				  },
				  function(Data){
					   if(Data==0){
							      $.messager.popover({
								      msg:'操作成功！',timeout: 3000,type:'info',showType: 'show',
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
								   var message="保存失败！"
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