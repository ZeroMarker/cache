var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
var startIndex = undefined;
var editIndex=undefined;
var orowid=""
$(function(){//初始化
    Init();
}); 
//rowid^Code^IP^Desc^Desc1^Desc2^Desc3^Desc4^CompName^Password
function Init(){
    MainColumns=[[ 
                {
	                field:'ck',
	                checkbox:true
	            }, 
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'CompName',title:'医疗单位',width:80,hidden: true},
                {field:'Code',title:'配置项编码',align:'center',width:140},
                {field:'IP',title:'配置项地址',align:'left',width:140},
                {field:'Desc',title:'描叙信息',align:'left',width:140},
                {field:'Desc1',title:'用户',align:'left',width:140},
                {field:'Password',title:'密码',align:'left',width:140},
                {field:'Desc3',title:'文件夹',align:'left',width:140}

            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgConfig",
            MethodName:"List",
            hospid : "", 
            Code:  "",
            Desc :    "",
            IP:""
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        singleSelect:true,
        rownumbers:true,//行号
        singleSelect: true, //只允许选中一行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onClickRow: onClickRow,  //在用户点击一行的时候触发
        onLoadSuccess:function(data){
            
        },
        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发
            
        },
        toolbar: [
        	{
	        	id: 'AddBn',
            	iconCls: 'icon-add',
           		text: '新增'
        	},{
	        	id: 'EditBn',
	        	iconCls: 'icon-write-order',
				text:'修改'
		    },{
	        	id: 'DeleteBn',
	        	iconCls: 'icon-cancel',
	        	text: '删除'
        	}]          
    }); 
    	//判断是否结束编辑
	function FYDEndEditing() {

		if (startIndex == undefined) {
			return true
		}
		if ($('#MainGrid').datagrid('validateRow', startIndex)) {
			var ed = $('#MainGrid').datagrid('getEditor', {
					index: startIndex,
					field: 'Code'
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
	   $('#MainGrid').datagrid('clearChecked')
	     clear();
	     $HUI.dialog('#CreateWin').open()
	  });
	
	$("#EditBn").click(function(){
	     //$HUI.dialog('#CreateWin').open()
	      var row=$('#MainGrid').datagrid('getChecked')[0];
        
         orowid=row.rowid
        
	     if(orowid==""){
		     return ;
	     }
	     Select(orowid);
	  });
	  
	 
    //点击一行时触发。
    function onClickRow(index){
        //var row=$('#MainGrid').datagrid('getRows')[index];  
        
        //alert(row.rowid)
        //$('#MainGrid').datagrid("beginEdit", index);             
    }
    $("#DeleteBn").click(function(){
	    var grid=$('#MainGrid');
        var rows = $('#MainGrid').datagrid("getSelections");
        
        if (CheckDataBeforeDel(rows) == true) {
            del(grid,"herp.budg.hisui.udata.uBudgConfig","Delete")
            //DFindBtn();
        } else {
            return;
        }
    });
    function CheckDataBeforeDel(rows) {
        if(!rows.length){
            $.messager.popover({
		        msg:'请选择所要删除的行！',
		        timeout: 2000,type:'alert',
		        showType: 'show',
		        style:{"position":"absolute","z-index":"9999",
		               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		               top:0.5}}); 
                return;
           };
        return true;
    };
     // 查询函数
     //sortField, sortDir, start, limit, hospid
    var DFindBtn= function()
    {
	    var code=$('#qcode').val();
	    var adress=$('#qaddress').val();
	    var desc=$('#qdesc').val();
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgConfig",
                MethodName:"List",
                hospid : "", 
                Code:  code,
                Desc :    desc,
                IP:adress
            })
    }

    // 点击查询按钮 
    $("#FindBn").click(DFindBtn);
    // 点击查询按钮 
    $("#SuerBT").click(function(){
	     Save();
	  });
	$HUI.linkbutton('#CancelBT',{
		  onClick:function(){
			 $HUI.dialog('#CreateWin').close();
		  }
	  });
	var clear=function (){
		$("#ccode").val("");
	    $("#caddress").val("");
	    $("#cdesc").val("");
	    $("#cuser").val("");
	    $("#cps").val("");
	    $("#cfold").val("");
	}
    var Save= function()
    {
	    
		var code = $("#ccode").val();
		if (code == '') {
			$.messager.popover({
				msg: '配置项编码不能为空!',
				type: 'info',
				timeout: 3000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 10
				}
			});
			return;
		}
		var address = $("#caddress").val();
		if (address == '') {
			$.messager.popover({
				msg: '配置项地址不能为空!',
				type: 'info',
				timeout: 3000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 10
				}
			});
			return;
		}

		var desc = $("#cdesc").val();
		if (desc == '') {
			$.messager.popover({
				msg: '描述信息不能为空!',
				type: 'info',
				timeout: 3000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 10
				}
			});
			return;
		}
		var user = $("#cuser").val();
		if (user == '') {
			$.messager.popover({
				msg: '用户名不能为空!',
				type: 'info',
				timeout: 3000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 10
				}
			});
			return;
		}
		var ps = $("#cps").val();
		if (ps == '') {
			$.messager.popover({
				msg: '密码不能为空!',
				type: 'info',
				timeout: 3000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 10
				}
			});
			return;
		}
		var fold = $("#cfold").val();
		if (fold == '') {
			$.messager.popover({
				msg: '文件夹不能为空!',
				type: 'info',
				timeout: 3000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 10
				}
			});
			return;
		}
		
		var data=code+"|"+address+"|"+desc+"|"+user+"|"+ps+"|"+fold+"|"+hospid;
	    var row=$('#MainGrid').datagrid("getSelected");
	    if (row==null){
		    var rorowid=""
		    }else{
			    rorowid=row.rowid}
	    $.m({
				 ClassName:'herp.budg.hisui.udata.uBudgConfig',
				 MethodName:'Save',
				 data : data,
				 rowid: rorowid
		},
		function(Data){
			      if(Data==0){
					 $.messager.popover({
		                msg: '保存成功！',
		                type:'success',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:0.5}});
						 //$('#MainGrid').datagrid("reload");
						 $HUI.dialog('#CreateWin').close();
						 DFindBtn();   	  
							      	 
					}else{
						$.messager.popover({
		                msg: '保存失败！'+Data,
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:0.5}
				        });
								    
					}
		});
	    
	    
	        
    }
    
    var Select=function (rowid){
	    var mianinfo=tkMakeServerCall("herp.budg.hisui.udata.uBudgConfig","Select",rowid);
		var arrinfo=mianinfo.split("^")
	    $("#ccode").val(arrinfo[0]);
	    $("#caddress").val(arrinfo[1]);
	    $("#cdesc").val(arrinfo[2]);
	    $("#cuser").val(arrinfo[3]);
	    $("#cps").val(arrinfo[4]);
	    $("#cfold").val(arrinfo[5]);
	    $HUI.dialog('#CreateWin').open()
    }
    //DFindBtn();
}