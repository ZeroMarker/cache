//页面Event
function InitListReportWinEvent(obj){
	
	//初始化信息
	obj.LoadEvent = function(args){ 
		obj.reCboTestSet();
		//初始化标本表
		obj.RefreshGridLabVisitNumber();
  	}
  	
  	
	//初始tab页签
	$HUI.tabs("#divTabs",{
		onSelect:function(title,index){
			//医嘱大类
			if (index==0) {
				obj.CatType=""
			}else{
				obj.CatType=index;
			}
			$('#cboTestSet').combobox('setValue',"")
			obj.RefreshGridLabVisitNumber();
			obj.reCboTestSet();
			//清空搜索框
			$("#SerchBox").searchbox('setValue',"");	
		}
	});
	//刷新检验医嘱	
	obj.RefreshGridLabVisitNumber=function(){
		obj.gridLabVisitNumber.load({
		   	ClassName:'DHCHAI.DPS.LabVisitRepSrv',
			QueryName:'QryLabVisitNumber',
			aEpisodeID:PaadmID,
			aDateFrom:"",
			aDateTo:"",
			aTestSetDr:$('#cboTestSet').combobox('getValue'),
			aCatCode:obj.CatType,
			aAlias:$('#SerchBox').searchbox('getValue')
	    });
	}
	//刷新检验结果(前台刷新)
	obj.RefreshGridLabVisitRepResult=function(){
		var Ret = $cm({
            ClassName: "DHCHAI.DPS.LabVisitRepSrv",
            QueryName: "QryVisitRepResult",
            aVisitRepID: obj.ReportID,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridLabVisitRepResult').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
    	});
	}
	//检索框
    $('#SerchBox').searchbox({
        searcher: function (value, name) {
           obj.RefreshGridLabVisitNumber();
        }
    });
        
    $HUI.dialog('#layerHisData',{
		title:'历次数据',
		iconCls:'icon-w-paper',
		width: 800,    
		height: 400, 
		modal: true,
		isTopZindex:true
	});			
	$('#btnHistory').on('click',function (e) {
		//$("#gridLabHisRepResult").empty();   //每次打开清空
		if (obj.LabOeordDesc!="") {
			var LabHisData = $cm ({									
				ClassName:"DHCHAI.DPS.LabVisitRepSrv",
				QueryName:"QryLabHisData",
				aEpisodeID:PaadmID,
				aLabItemDesc:obj.LabOeordDesc,
				page: 1,
            	rows: 999
			},false);
			var HisLen=LabHisData.total;
			$("#gridLabHisRepResult thead").html("");
			$("#gridLabHisRepResult tbody").html("");
			obj.HeadArray = new Array();
			var headhtml  = "<tr><th>项目</th>";
			var bodyhtml1row  = "<tr><td>检验号</td>";
			var bodyhtml2row  = "<tr><td>送检日期</td>";
			var ColCnt=0;
			
			// 处理表头、检验号、送检日期三行
			for (var j=0;j<HisLen;j++){
				var VisitReportID = LabHisData.rows[j].VisitReportID;
				var EpisodeNo = LabHisData.rows[j].EpisodeNo;
				var CollDate  = LabHisData.rows[j].CollDate;
				var TestDesc  = LabHisData.rows[j].TestDesc;
				if (obj.HeadArray.indexOf(VisitReportID)<0){
					obj.HeadArray.push(VisitReportID);
					headhtml+="<th>值"+(++ColCnt)+"</th>";
					bodyhtml1row+="<td>"+EpisodeNo+"</td>";
					bodyhtml2row+="<td>"+CollDate+"</td>";
				}
			}
			headhtml+="</tr>";
			$("#gridLabHisRepResult thead").html(headhtml);
			bodyhtml1row+="</tr>";
			bodyhtml2row+="</tr>";
			$("#gridLabHisRepResult thead").append(bodyhtml1row+bodyhtml2row);
		
			// 处理表体
			var bodyhtml  = "";
			for (var j=0;j<HisLen;j++){ //先生成行列 ,再填充数据
				var VisitReportID = LabHisData.rows[j].VisitReportID;			
				var TestDesc = LabHisData.rows[j].TestDesc;
				var TestCode = LabHisData.rows[j].TestCode;
				var Result = LabHisData.rows[j].Result;
				var AbFlag = LabHisData.rows[j].AbFlag;		
				
				//异常提示
				if (typeof obj.AbFlagBack[AbFlag] != "undefined"){
					Result = '<div style="background:'+obj.AbFlagBack[AbFlag]+';width:100%;color:white;">'+AbFlag+ "&nbsp;&nbsp;" +Result+ '</div>';
				}
				
				if (bodyhtml.indexOf("<tr id="+TestCode+">")<0){							
					bodyhtml+="<tr id="+TestCode+"><td>"+TestDesc+"</td></tr>";
					var tmpbodyhtml="<tr id="+TestCode+"><td style='word-break:keep-all;white-space:nowrap;'>"+TestDesc+"</td></tr>";
					$("#gridLabHisRepResult tbody").append(tmpbodyhtml);
				}
				
				if (($("tr#"+TestCode+" td").length)<(ColCnt+1)){
					var tmphtml="";
					$("tr#"+TestCode+" td:not(:first-child)").html("");
					for (var i=$("tr#"+TestCode+" td").length;i<(ColCnt+1);i++){
						var ind = obj.HeadArray[i-1];
						tmphtml+="<td id='td_"+TestCode+"_"+ind+"'></td>";
					}
					$("tr#"+TestCode).append(tmphtml);
				}
			
				$('#'+'td_'+TestCode+"_"+VisitReportID).html(Result);  //填充数据				
			}
			
			$HUI.dialog('#layerHisData').open();
			
				
		}else{
			$.messager.popover({msg: '请选择检验医嘱!',type:'error',timeout: 2000});
			return;
		}
	});
	
	
}

