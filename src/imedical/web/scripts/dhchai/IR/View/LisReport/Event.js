//页面Event
function InitLisReportWinEvent(obj){
	$.form.SelectRender("cboTestSet");  //渲染下拉框
	
	$('#cboTestSet').on('change',function(){
		obj.gridLabVisitNumber.ajax.reload();
	});
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridLabVisitNumber').DataTable().search($('#search').val(),false,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridLabVisitNumber.search(this.value).draw();
        }
    });
    /****************/
	
	obj.gridLabVisitNumber.on('select', function(e, dt, type, indexes) {
		if ( type === 'row' ) {
	        var data = obj.gridLabVisitNumber.rows(indexes).data();
	        obj.ReportID = data[0].VisitReportID;
	        obj.LabOeordDesc = data[0].OrdTSDesc;
	        $("#HisData > span").html(obj.LabOeordDesc+" ");
	 		obj.gridLabVisitRepResult.ajax.reload(function(){
	 			// obj.gridLabVisitRepResult.on( 'draw.dt', function () {
					$("tfoot").remove();
					var html = "";
					for (var i=0;i<arguments[0].data.length;i++){
						var RstFormat = arguments[0].data[i].RstFormat;
						var ResultID = arguments[0].data[i].ResultID;
						var ResuntSen = $.Tool.RunQuery("DHCHAI.DPS.LabVisitRepSrv","QryResultSen",ResultID);
						if (ResuntSen.total){
							
							//html+="<tfoot style='font-size:12px;padding-top:10;width:430;'>";
					        html+="<tr><td colspan='3' style='color:#40a2de;font-weight:bold;border-top:0;text-align:center;border-right-width:1px;'>"+arguments[0].data[i].Result+"</td></tr>";
							html+="<tr style='font-weight:bold'>";
							html+="<td style='border-top:0;'>抗生素代码</td>";
							html+="<td style='border-top:0;'>抗生素名称</td>";
							html+="<td style='border-top:0;border-right-width:1px;'>结果</td>";
							html+="</tr>";
							var ResuntSen = $.Tool.RunQuery("DHCHAI.DPS.LabVisitRepSrv","QryResultSen",ResultID);
							for (var j=0;j<ResuntSen.total;j++){
								html+="<tr>";
								html+="<td style='border-top:0;'>"+ResuntSen.record[j].AntCode+"</td>";
								html+="<td style='border-top:0;'>"+ResuntSen.record[j].AntDesc+"</td>";
								html+="<td style='border-top:0;border-right-width:1px;'>"+ResuntSen.record[j].Sensitivity+ ((ResuntSen.record[j].IsInt==1) ? '<div style="display:inline;margin-left:3px;background-color:red;color:#fff;border-radius:3px;font-size:10px;padding:2px;width:18px;font-weight: 600;">天</div>' :'')+"</td>";
								html+="</tr>";
							}
							//html+="<tfoot>"; 
							
						}
					}
					if (html!=""){
						html ="<tfoot><tr>"+"<th colspan='6'><table cellspacing='0' style='white-space: nowrap;' width='100%'><tbody style='font-size:12px;padding-top:10;width:430;'>"+html+"</tbody></table></th>"+"</tr></tfoot>";
						$("#gridLabVisitRepResult").append(html);
					}
					var rowheight = $("#gridLabVisitRepResult_wrapper tr").css("height");
					$("#gridLabVisitRepResult_wrapper .dataTables_scrollBody").css("max-height",parseInt(rowheight.split("px")[0])*11+"px")
				// });
	 		});
	    }
	});
	
	$('#HisData > a').on('click',function (e) {
		if (obj.LabOeordDesc!="") {
			var html="";
			var LabHisData = $.Tool.RunQuery("DHCHAI.DPS.LabVisitRepSrv","QryLabHisData",PaadmID,obj.LabOeordDesc,"","");
			if (LabHisData.total==0){
				layer.msg('该项目无历次检验结果!',{icon: 0});
				return;
			}
			$("#gridLabHisRepResult thead").html("");
			$("#gridLabHisRepResult tbody").html("");
			obj.HeadArray = new Array();

			var headhtml  = "<tr><th style='border-top:0;text-align:center;'>项目</th>";
			var bodyhtml1row  = "<tr><td style='border-top:0;text-align:center;'>检验号</td>";
			var bodyhtml2row  = "<tr><td style='border-top:0;text-align:center;'>送检日期</td>";
			var ColCnt=0;
			
			// 处理表头、检验号、送检日期三行
			for (var j=0;j<LabHisData.total;j++){
				var VisitReportID = LabHisData.record[j].VisitReportID;
				var EpisodeNo = LabHisData.record[j].EpisodeNo;
				var CollDate  = LabHisData.record[j].CollDate;
				var TestDesc  = LabHisData.record[j].TestDesc;
				if (obj.HeadArray.indexOf(VisitReportID)<0){
					obj.HeadArray.push(VisitReportID);
					headhtml+="<th style='border-top:0;text-align:center;'>值"+(++ColCnt)+"</th>";
					bodyhtml1row+="<td style='border-top:0;text-align:center;'>"+EpisodeNo+"</td>";
					bodyhtml2row+="<td style='border-top:0;text-align:center;'>"+CollDate+"</td>";
				}
			}
			headhtml+="</tr>";
			$("#gridLabHisRepResult thead").html(headhtml);
			bodyhtml1row+="</tr>";
			bodyhtml2row+="</tr>";
			$("#gridLabHisRepResult tbody").html(bodyhtml1row+bodyhtml2row);
			// 处理表体
			var bodyhtml  = "";
			for (var j=0;j<LabHisData.total;j++){ //先生成行列 ,再填充数据
				var VisitReportID = LabHisData.record[j].VisitReportID;			
				var TestDesc = LabHisData.record[j].TestDesc;
				var TestCode = LabHisData.record[j].TestCode;
				var Result = LabHisData.record[j].Result;
				var AbFlag = LabHisData.record[j].AbFlag;		
				
				//异常提示
				if (typeof obj.AbFlagBack[AbFlag] != "undefined"){
					Result = '<div style="background:'+obj.AbFlagBack[AbFlag]+';width:100%;">'+AbFlag+ "&nbsp;&nbsp;" +Result+ '</div>';
				}
				
				if (bodyhtml.indexOf("<tr id="+TestCode+">")<0){							
					bodyhtml+="<tr id="+TestCode+"><td style='border-top:0;text-align:center;'>"+TestDesc+"</td></tr>";
					var tmpbodyhtml="<tr id="+TestCode+"><td style='border-top:0;text-align:center;'>"+TestDesc+"</td></tr>";
					$("#gridLabHisRepResult tbody").append(tmpbodyhtml);
				}
				
				if (($("tr#"+TestCode+" td").length)<(ColCnt+1)){
					var tmphtml="";
					$("tr#"+TestCode+" td:not(:first-child)").html("");
					for (var i=$("tr#"+TestCode+" td").length;i<(ColCnt+1);i++){
						var ind = obj.HeadArray[i-1];
						tmphtml+="<td id='td_"+TestCode+"_"+ind+"' style='border-top:0;text-align:center;'></td>";
					}
					$("tr#"+TestCode).append(tmphtml);
				}
			
				$('#'+'td_'+TestCode+"_"+VisitReportID).html(Result);  //填充数据				
			}
			/*
			for (var j=0;j<LabHisData.total;j++){
				var TestDesc = LabHisData.record[j].TestDesc;
				var TestCode = LabHisData.record[j].TestCode;
				var Result = LabHisData.record[j].Result;
				var AbFlag = LabHisData.record[j].AbFlag;
				//异常提示
				if (typeof obj.AbFlagBack[AbFlag] != "undefined"){
					Result = '<div style="background:'+obj.AbFlagBack[AbFlag]+';width:100%;">'+AbFlag+ "&nbsp;&nbsp;" +Result+ '</div>';
				}
				
				if (bodyhtml.indexOf("<tr id="+TestCode+">")<0){
					bodyhtml+="<tr id="+TestCode+"><td style='border-top:0;text-align:center;'>"+TestDesc+"</td><td style='border-top:0;text-align:center;'>"+Result+"</td></tr>";
					var tmpbodyhtml="<tr id="+TestCode+"><td style='border-top:0;text-align:center;'>"+TestDesc+"</td><td style='border-top:0;text-align:center;'>"+Result+"</td></tr>";
					$("#gridLabHisRepResult tbody").append(tmpbodyhtml);
				}else {
					$("tr#"+TestCode).append("<td style='border-top:0;text-align:center;'>"+Result+"</td>");
				}
			}
			// 处理项目少了的值没对齐
			for (var j=0;j<LabHisData.total;j++){
				var TestDesc = LabHisData.record[j].TestDesc;
				var TestCode = LabHisData.record[j].TestCode;
				var Result = LabHisData.record[j].Result;
				// 先补齐TD,清除TD 
				if (($("tr#"+TestCode+" td").length)<(ColCnt+1)){
					var tmphtml="";
					$("tr#"+TestCode+" td:not(:first-child)").html("");
					for (var i=$("tr#"+TestCode+" td").length;i<(ColCnt+1);i++){
						tmphtml+="<td style='border-top:0;text-align:center;'></td>";
					}
					$("tr#"+TestCode).append(tmphtml);
				}
				var ColIndex = (j%ColCnt);
				if (ColIndex==0){
					ColIndex=ColCnt;
				}
				$("tr#"+TestCode+" td").eq(ColIndex).html(Result);
			}
			*/
			obj.Layer();
			$("#gridLabHisRepResult tr").click(function(){
		        $(this).css("background-color","#0088CC");
		        $(this).siblings("tr").css('background-color', "");
		    });
		}else{
			layer.msg('请选择检验医嘱!',{icon: 0});
		}
	});
	
	// 历次检验结果
	obj.Layer = function(){
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: ['700px','460px'],
			skin: 'layer-class',
			title: '历次检验结果查看', 
			scrollbar: false,
			content: $('#layer_HisData'),
			success: function(layero){
				
			}
		}); 
	}
}

