//初始化
function InitIExARepWinEvent(obj) {
    obj.LoadEvent = function () {
        obj.date = new Date();
        obj.year = obj.date.getFullYear();
        obj.month = obj.date.getMonth()+1;
        obj.refreshgridIExAReport();
    }
    
    //获取单元格里面的内容 根据患者id调用后端，返回每一天的信息 再根据信息去填充相应的图标
    obj.GetCellRet = function (value,row,index) { 
        //value 0:社区感染 IsCA 1:上月医院感染且尚未治愈 IsNotCure  2:医院感染： IsHA 3:新发另一感染部位：IsOtherHA 4:患者在院：IsInHospital
         var ret="";
        //value="1|0|0|0|0"
        var IsCA=String(value).split("|")[0]
        var IsNotCure=String(value).split("|")[1]
        var IsHA=String(value).split("|")[2]
        var IsOtherHA=String(value).split("|")[3]
        var PosDesc=String(value).split("|")[5]
        var InfDate=String(value).split("|")[6]
        if(IsCA=="1")//
        {
            ret= '<span class="pull-left circleGrid" title="'+PosDesc+' 感染日期:'+InfDate+'" style="background-color:#333;margin-top:4px;" ></span>';
        }
        if(IsNotCure=="1"){
            ret= '<span class="pull-left circleGrid" title="'+PosDesc+' 感染日期:'+InfDate+'" style="background-color:#607D8B;margin-top:4px;" ></span>';
        }
        if(IsHA=="1"){
            ret= '<span class="pull-left circleGrid" title="'+PosDesc+' 感染日期:'+InfDate+'" style="background-color:#ff0000;margin-top:4px;" ></span>';
            
        }
        if(IsOtherHA=="1"){
            ret= '<span class="pull-left circleGrid" title="'+PosDesc+' 感染日期:'+InfDate+'" style="background-color:#FFC107;margin-top:4px;" ></span>';
        }	
         return ret;
    }
    
   
	
    //'显示全部'选中事件
	$HUI.radio("[name='chkStatunit']", {
       	 onCheckChange: function () {
           	obj.refreshGridIExAReport();
		}
	})
    //刷新在院患者内容
    obj.refreshgridIExAReport = function () {
        //入参：1.aLocID:科室ID 2.aYYMM：在院年月
	   	$("#gridIntuRep").datagrid("loading");
		var Ret = $cm({
			ClassName: "DHCHAI.IRS.WardDetailsSrv",
            QueryName: "QryPaadmRepByMonth",
            aYYMM:obj.year+"-"+obj.month,
            aLocDr:obj.LocDr,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridIntuRep').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
		});
        var d = new Date(obj.year, obj.month, 0);   
        var dataCount=d.getDate();
        //如果当月小于31天则隐藏该列
        var DateDiff=31-dataCount
        if(DateDiff>0){
            if(DateDiff==1){
                $("#gridIntuRep").datagrid("hideColumn", "Date31"); // 设置隐藏列 
                $("#gridIntuRep").datagrid("showColumn", "Date30"); 
                $("#gridIntuRep").datagrid("showColumn", "Date29"); 
            }
            if(DateDiff==2){
                $("#gridIntuRep").datagrid("hideColumn", "Date31"); // 设置隐藏列
                $("#gridIntuRep").datagrid("hideColumn", "Date30"); // 设置隐藏列 
                $("#gridIntuRep").datagrid("showColumn", "Date29"); 
            } 
            if(DateDiff==3){
                $("#gridIntuRep").datagrid("hideColumn", "Date31"); // 设置隐藏列
                $("#gridIntuRep").datagrid("hideColumn", "Date30"); // 设置隐藏列 
                $("#gridIntuRep").datagrid("hideColumn", "Date29"); // 设置隐藏列 
            } 
            } 
            else{
                $("#gridIntuRep").datagrid("showColumn", "Date31");  
                $("#gridIntuRep").datagrid("showColumn", "Date30"); 
                $("#gridIntuRep").datagrid("showColumn", "Date29"); 
            }
        var month=obj.getdate(obj.month)
        for (var i = 1; i <= dataCount; i++) {
            var filed = 'Date' + i;
            var Day =i;
            var day=obj.getdate(i)
            var bcolumn = $('#gridIntuRep').datagrid('getColumnOption', filed);
            bcolumn.title = month+""+day+"";
        };
    }
    obj.getdate=function(value) {
      return date=value< 10 ? "0" + value: value;
    }

}


