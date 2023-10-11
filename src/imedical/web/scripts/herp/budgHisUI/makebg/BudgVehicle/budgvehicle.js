var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
var startIndex = undefined;
var editIndex=undefined;
var orowid=""
$(function(){//初始化
    
    Init();
}); 

function Init(){
	var YMboxObj = $HUI.combobox("#Databox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetCategory",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'fdesc',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
    var TravelToolObj = $HUI.combobox("#Toolbox",{
	    valueField:'id', 
	    textField:'text',
	    defaultFilter:4,
	    data:[
			{id:'高铁',text:'高铁'}
			,{id:'动车',text:'动车'}
			,{id:'火车',text:'火车'}
			,{id:'飞机',text:'飞机'}
			,{id:'地铁',text:'地铁'}
			,{id:'客轮',text:'客轮'}
			,{id:'出租汽车',text:'出租汽车'}
			,{id:'公共汽车',text:'公共汽车'}
		],
    });
    
    
    var YMboxObj = $HUI.combobox("#NDatabox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetCategory",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'fdesc',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
    var TravelToolObj = $HUI.combobox("#NToolbox",{
	    valueField:'id', 
	    textField:'text',
	    defaultFilter:4,
	    data:[
			{id:'高铁',text:'高铁'}
			,{id:'动车',text:'动车'}
			,{id:'火车',text:'火车'}
			,{id:'飞机',text:'飞机'}
			,{id:'地铁',text:'地铁'}
			,{id:'客轮',text:'客轮'}
			,{id:'出租汽车',text:'出租汽车'}
			,{id:'公共汽车',text:'公共汽车'}
		],
    });
    
    MainColumns=[[
    
    {
	    field:"ckbox",
	    checkbox:true,
    },
    {
	    field:'rowid',
	    title:'ID',
	    width:80,
	    hidden: true
    },
    {
	    field:'CompDR',
	    title:'医院ID',
	    width:80,
	    hidden: true
	    
    },
    {
	    field:'AddStart',
	    title:'出发地点',
	    width:150,
	    align:'left',    
    },
    {
	    field:'AddEnd',
	    title:'目的地点',
	    width:150,
	    align:'left',
    },
    {
	    field:'TravelTool',
	    title:'交通工具',
	    width:150,
	    align:'left',   
    },
    {
	    field:'TravelValue',
	    title:'标准费用',
	    width:150,
	    align:'left',
	    formatter:dataFormat,
	    type:'numberbox',
	    options:{precision: 2}
    },
    {
	    field:'Category',
	    title:'人员类型',
	    width:150,
	    formatter:function(value,row){
						return row.FDesc;
					},                
    }
    ]];
    
    var MainGridObj = $HUI.datagrid("#MainGrid",{
	    url:$URL,
	    queryParams:{
		    ClassName:'herp.budg.hisui.udata.uBudgVehicle',
		    MethodName:'List',
		    hospid: hospid,
		    AddStart: '',
		    AddEnd: '',
		    TravelTool: '',
		    TravelValue: '',
		    Category: ''
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
            del(grid,"herp.budg.hisui.udata.uBudgVehicle","Delete")
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
    var DFindBtn= function()
    {
	    var AddStart=$('#citySelect').val();
	    var AddEnd=$('#citySelectTwo').val();
	    var TravelTool=$('#Toolbox').combobox('getValue');
	    var Category=$('#Databox').combobox('getValue');
         MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgVehicle",
                MethodName:"List",
                hospid: hospid,
		        AddStart: AddStart,
		        AddEnd: AddEnd,
		        TravelTool: TravelTool,
		        TravelValue: "",
		        Category: Category
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
		$("#citySelectThree").val("");
	    $("#citySelectFour").val("");
	    $("#TravelValue").val("");
	    $('#NToolbox').combobox('setValue',"");
	    $('#NDatabox').combobox('setValue',"")
	}
	
	var Save= function()
    {
	    
		var AddStart = $("#citySelectThree").val();
		//alert(TravelStatr)
		if (AddStart == '') {
			$.messager.popover({
				msg: '出发城市不能为空!',
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
		var AddEnd = $("#citySelectFour").val();
		//alert(TravelEnd)
		if (AddEnd == '') {
			$.messager.popover({
				msg: '目的城市不能为空!',
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

		var TravelValue = $("#TravelValue").val();
		if (TravelValue == '') {
			$.messager.popover({
				msg: '标准费用不能为空!',
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
		var TravelTool = $("#NToolbox").combobox('getValue');
		//alert(TravelTool)
		if (TravelTool == '') {
			$.messager.popover({
				msg: '交通工具不能为空!',
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
		var Category = $("#NDatabox").combobox('getValue');
		
		if (Category == '') {
			$.messager.popover({
				msg: '人员类别不能为空!',
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
		//var data=code+"|"+address+"|"+desc+"|"+user+"|"+ps+"|"+fold+"|"+hospid;
		//AddStart, AddEnd, TravelTool, TravelValue, Category, CompDR
	    var row=$('#MainGrid').datagrid("getSelected");
	    if (row==null){
		    var rorowid=""
		    }else{
			    rorowid=row.rowid}
	    $.m({
				 ClassName:'herp.budg.hisui.udata.uBudgVehicle',
				 MethodName:'Save',
				 AddStart : AddStart,
				 AddEnd: AddEnd,
				 TravelTool : TravelTool,
				 TravelValue : TravelValue,
				 Category : Category,
				 CompDR : hospid,
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
	    var mianinfo=tkMakeServerCall("herp.budg.hisui.udata.uBudgVehicle","Select",rowid);
	     //alert(mianinfo)
		
		var arrinfo=mianinfo.split("^")
		//alert(arrinfo)
	    $("#citySelectThree").val(arrinfo[0]);
	    $("#citySelectFour").val(arrinfo[1]);
	    $("#TravelValue").val(arrinfo[3]);
	    $('#NToolbox').combobox('setValue', arrinfo[2]);
	    $('#NDatabox').combobox('setValue', arrinfo[4]);
	    $HUI.dialog('#CreateWin').open()
    }
    //DFindBtn();
    
    
    
    
    
    
    
    
    
    
    
    
    
    
      
     
    
     
	 
           
        
        
         
       
		
		
	  
				  
	       
	
	
	
}


 