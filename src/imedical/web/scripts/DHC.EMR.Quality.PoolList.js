//程序入口
$(function(){
	initDataList()
	getQualityRule()
	getQualityStruct()
})

//加载质控标准
function getQualityRule(){
	$('#comboQualiytRule').combobox
	({
		valueField:'RowID',  
	    textField:'RuleName',
		url:'../EPRservice.Quality.Ajax.QualityRule.cls?ARuleDesc=&ARuleCodes=',
		onSelect: function() {
			doSearch()
        }
    });
}

//加载质控结构（只加载手工评分的质控结构）
function getQualityStruct(){
	$('#comboQualiytStruct').combobox
	({
		valueField:'StructID',  
	    textField:'StructName',
		url:'../EPRservice.Quality.Ajax.GetStructResult.cls?Action=A',
		onSelect: function() {
			doSearch()
        }
    });
}

//更改质控条目状态
function changeRuleState(entryId,isActive){
	$cm({
		ClassName:"EPRservice.Quality.DataAccess.BOQualityEntry",
		MethodName:"ChangeStateByEntryId",
		entryId:entryId,
		isActive:isActive,
		dataType:'text'
	},function(res){
		if(res!="1") $.messager.alert("提示","更新失败!","error")
	})
}

//初始化数据表格
function initDataList(){
	$('#ruleList').datagrid({ 
			pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
			fitColumns: true,
			method: 'get',
            loadMsg: '加载中......',
			autoRowHeight: true,
			url:'../EPRservice.Quality.Ajax.GetPoolInfo.cls',
			queryParams: {
                ruleId: "2",
				structId: ""
            },
			singleSelect:true,
			fit:true,
			columns:[[
				{field:'active',title:'是否有效',width:30,align:'center',formatter:function(value,rowData,rowIndex){
					console.log(rowData)
					if(value==="Y"){
						return "<div entryId="+rowData.rowId+" class='myswitch'><span class='spanOpen'></span></div>"	
					}else{
						return "<div entryId="+rowData.rowId+" class='myswitch switchClose'><span class='spanClose'></span></div>"
					}
					
				}
				},
				{field:'title',title:'规则描述',width:200,align:'center'},
				{field:'structDesc',title:'质控结构',width:100,align:'center'},
				{field:'score',title:'分数',width:30,align:'center'},
				{field:'vetoGrade',title:'单否等级',width:30,align:'center'}
				
			]],
		  onLoadSuccess:function(){
		  		changeState()
		  },
		  loadFilter:function(data)
		  {
			  if(typeof data.length == 'number' && typeof data.splice == 'function'){
				  data={total: data.length,rows: data}
			  }
    		  var dg=$(this);
    		  var opts=dg.datagrid('options');
              var pager=dg.datagrid('getPager');
              pager.pagination({
    	      	onSelectPage:function(pageNum, pageSize){
	    	      	opts.pageNumber=pageNum;
        	 	  	opts.pageSize=pageSize;
        	     	pager.pagination('refresh',{pageNumber:pageNum,pageSize:pageSize});
        	     	dg.datagrid('loadData',data);
        	    }
              });
    		  if(!data.originalRows){
	    		  data.originalRows = (data.rows);
              }
   		 	  var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
              var end = start + parseInt(opts.pageSize);
              data.rows = (data.originalRows.slice(start, end));
              return data;
          }
	  }); 
}

//查询

function doSearch(){
	//质控标准
	var ruleId=$("#comboQualiytRule").combobox("getValue")

	//质控结构
	var structId=$("#comboQualiytStruct").combobox("getValue")
	
	$('#ruleList').datagrid("options").queryParams.ruleId=ruleId
	
	$('#ruleList').datagrid("options").queryParams.structId=structId
	
	$('#ruleList').datagrid("reload")
}

//开关初始化
function changeState(){
    var animateGap="28px"
    
    var myswitches=$(".myswitch")
    
    for(var i=0;i<myswitches.length;i++){
		$(myswitches[i]).click(function(){
			var entryId=$(this).attr("entryId")
	        if($(this).children().css("left")==animateGap){
	            $(this).children().animate({left:'0px'})
	            $(this).css("background-color","rgb(19, 206, 102)")
	            changeRuleState(entryId,"Y")
	        }else{
	            $(this).children().animate({left:animateGap})
	            $(this).css("background-color","gray")
	            changeRuleState(entryId,"N")
	        }
    	})   	
	} 
}


