/*
Creator: 
CreatDate: 
Description: 全面预算管理-预算编制平衡-预算数据操作
CSPName: herp.budg.hisui.budgdataoper.csp
ClassName: herp.budg.common.BasicMethod--SplitCal（年度分解到月）,
herp.budg.udata.uBudgFactSummarize--UpdSummarizeS（上级科目汇总）
herp.budg.udata.uBudgFactSummarize--DeptUpSum（科室汇总全院）
 */


$(function(){//初始化
    Init();
}); 

function Init(){
//预算年度的下拉框
   var yearObj = $HUI.combobox("#yearCmb",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.flag = ""
        },
        onSelect:function(data){ 
	        //console.log(JSON.stringify(data));
	        $('#schemeField').combobox('clear'); //清除原来的数据
	        var Url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem&hospid="+hospid+"&userdr="+userid+"&year="+data.year;
	        $('#schemeField').combobox('reload',Url);//联动下拉列表重载
	        $('#adjNo').combobox('clear'); //清除原来的数据
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=AdjustNo&hospid="+hospid+"&userdr="+userid+"&flag=1+&year="+data.year;
	        $('#adjNo').combobox('reload',url);//联动下拉列表重载
        }
   });

 //方案名称的下拉框
   var schemeObj = $HUI.combobox("#schemeField",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:
            function(param){
	            param.str = param.q;
	            param.flag = "";
	            param.hospid = hospid;
	            param.userdr = userid;
	            param.year = $('#yearCmb').combobox('getValue');
            }
   })
    
   //预算额度的下拉框
   var ChangeFlagObj =  $HUI.combobox("#ChangeFlagStore",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        data: [{
                    'rowid': 1,
                    'name': "期初预算"
                },{
                    'rowid': 2,
                    'name': "调整后预算"
                }]
     });
   
   //调整序号的下拉框  
   $("#ChangeFlagStore").combobox({
	       onChange:function(newvalue){
	         if(newvalue==2){
		         $("#adjNo").combobox("enable");
	          } else{
		         $("#adjNo").combobox("disable");
		      }
    }
    
    });
   var adjObj = $HUI.combobox("#adjNo",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=AdjustNo",
        mode:'remote',
        delay:200,
        valueField:'AdjustNo',    
        textField:'AdjustNo',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.flag = 1;
            param.hospid = hospid;
            param.userdr = userid;
            param.year = $('#yearCmb').combobox('getValue');
        }
   });
 $(".combo").click(function(){
               //$(this).prev().combobox("showPanel");
               var year = $('#yearCmb').combobox('getValue');  
	       if (!year) {
	           $.messager.popover({
		       msg:'请先选择年度！',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
               return;
         }
     });
 //按钮--年度预算分解到月
  $("#splitBtn").click(function(){
	  $.messager.confirm('确定','确认分解吗？',function(t){
		 if(t){
        var year = $('#yearCmb').combobox('getValue');
        var ChangeFlag = $('#ChangeFlagStore').combobox('getValue');
        var adjNo = $('#adjNo').combobox('getValue');
        if (year == "") {
	       $.messager.popover({
		       msg:'预算年度不能为空!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
        if (ChangeFlag == "") {
	       $.messager.popover({
		       msg:'预算额度不能为空!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         }else  if ((ChangeFlag == "2") && (adjNo == "")) {
	       $.messager.popover({
		       msg:'调整序号不能为空!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         $.messager.progress({
			 title: '提示',
			 msg: '数据处理中...'
	                  });
	                  
	     var year = $('#yearCmb').combobox('getValue');
	     var schemDr = $('#schemeField').combobox('getValue');
	     var changeFlag = $('#ChangeFlagStore').combobox('getValue');
	     var adjNo = $('#adjNo').combobox('getValue');
         $.m({
            ClassName:'herp.budg.common.BasicMethod',
            MethodName:'SplitCal',
            hospid: hospid,
            splLayer: "",
            year: year,
            schemDr:schemDr,
            changeFlag:changeFlag,
            adjNo:adjNo
            },
            
            function(jsonData){
                 if(jsonData == -1){
	                $.messager.popover({
		                msg: '预算已下达,禁止操作!',
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});     
                }else if(jsonData == 0){
	                $.messager.popover({
		                msg: '分解成功！',
		                type:'success',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
                }else{
	                $.messager.popover({
		                msg: '分解失败'+ jsonData,
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
	              }
                $.messager.progress('close');
              }
            );
		 }
	  })
	});
	//按钮--上级科目汇总
	$("#SummarizeButton").click(function(){
		$.messager.confirm('确定','确认汇总吗？',function(t){
		 if(t){ 
        var year = $('#yearCmb').combobox('getValue');
        var ChangeFlag = $('#ChangeFlagStore').combobox('getValue');
        var adjNo = $('#adjNo').combobox('getValue');
        if (year == "") {
	       $.messager.popover({
		       msg:'预算年度不能为空!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
        if (ChangeFlag == "") {
	       $.messager.popover({
		       msg:'预算额度不能为空!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
       
         $.messager.progress({
			 title: '提示',
			 msg: '数据正在处理中...'
	                  });
	                  
	     var year = $('#yearCmb').combobox('getValue');
	     var changeFlag = $('#ChangeFlagStore').combobox('getValue');
         $.m({
            ClassName:'herp.budg.udata.uBudgFactSummarize',
            MethodName:'SumNotLastItemBudg',
            hospid: hospid,
            year: year,
            changeFlag:changeFlag
            },
            
            function(SQLCODE){
                 if(SQLCODE == 0){
	                $.messager.popover({
		                msg: '数据操作成功!',
		                type:'success',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
                }else{
	                $.messager.popover({
		                msg: '数据操作失败!'+SQLCODE,
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
	              }
                $.messager.progress('close');
              }
            )
		 }
		})
	});
	//按钮--科室汇总全院
	$("#DSummarizeButton").click(function(){
		$.messager.confirm('确定','确认汇总吗？',function(t){
		 if(t){ 
        var year = $('#yearCmb').combobox('getValue');
        var ChangeFlag = $('#ChangeFlagStore').combobox('getValue');
        var adjNo = $('#adjNo').combobox('getValue');
        if (year == "") {
	       $.messager.popover({
		       msg:'预算年度不能为空!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
        if (ChangeFlag == "") {
	       $.messager.popover({
		       msg:'预算额度不能为空!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
       
         $.messager.progress({
			 title: '提示',
			 msg: '数据正在处理中...'
	                  });
	                  
	     var year = $('#yearCmb').combobox('getValue');
	     var changeFlag = $('#ChangeFlagStore').combobox('getValue');
         $.m({
            ClassName:'herp.budg.udata.uBudgFactSummarize',
            MethodName:'SumHospItemsYMValues',
            hospid: hospid,
            year: year,
            changeFlag:changeFlag
            },
            
            function(SQLCODE){
                 if(SQLCODE == 0){
	                $.messager.popover({
		                msg: '数据操作成功!',
		                type:'success',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
                }else{
	                $.messager.popover({
		                msg: '数据操作失败!'+SQLCODE,
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
	              }
                $.messager.progress('close');
              }
            )
		 }
		}) 	 
	});
}	
