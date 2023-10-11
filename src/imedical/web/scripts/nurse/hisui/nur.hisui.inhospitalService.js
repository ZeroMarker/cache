// -----------------------------------------------------
var SortType=1; //排序方式-默认
var hospID,wardsData=[];
if ('undefined'==typeof HISUIStyleCode) {
	var HISUIStyleCode="blue";
}
$(function() {
	//hospComp = GenHospComp("Nur_IP_DataTab",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	hospID=session["LOGON.HOSPID"]; //hospComp.getValue();
	/*hospComp.options().onSelect = function(i,d){
	}  ///选中事件*/
	findWardBedData();
	$("#ihsWards").next('div.panel').css({
		marginTop: '-0.5em',
		display:'none'
	}).hide();
	InitLocBuilding();
	//InitLocBuildingFloor();
	if ('lite'==HISUIStyleCode) { //极简
		$('#menubtn-toolbar>span>span.l-btn-text').css('line-height','22px');
		if (IsPopUp) { //极简弹窗
			$('.eduExeStyle').append('body>div>div>div{background: #ffffff!important;}');
		}
	}
})
// 查询病区床位患者
function findWardBedData() {
	$cm({
    	ClassName: 'Nur.NIS.Service.Base.Bed',
    	QueryName: 'GetWardBedsAndLeaveHospData',
    	hospitalId: hospID,
    	rows:99999
  	}, function (data) {
  		wardsData=data.rows;
  		filterWardsData();
  	});
}
// 过滤病区
function filterWardsData() {
	var DisplayType=SortType;
	var wardName=$("#wardName").searchbox('getValue').toUpperCase();
	var selKeys=$("#LocBuilding").keywords("getSelected"); //$("#LocBuilding").combobox("getValue");
	var arrnew = selKeys.map(function(obj){
		return obj.id;
	})
	var LocBuilding=arrnew.length?("^"+arrnew.join("^")+"^"):"";
	//var LocBuildingFloor=$("#LocBuildingFloor").combobox("getValue");
	var str1="",filterData=[];
	if (DisplayType =="1"){
		wardsData.map(function(elem) {
			var LocFloor="";
			if (elem.CTLBDesc) {
				LocFloor=elem.CTLBDesc+'-'+elem.CTLBFFloor;
			}
			if (((elem.warddesc.includes(wardName)||(elem.LocContactName.includes(wardName))))&&(((!LocBuilding)||(LocBuilding)&&(LocBuilding.indexOf("^"+elem.LocFloorId.split("||")[0]+"^")>=0)))) {
				str1+='<div class="ihsWard"><div data-wardid="'+elem.wardId+'"><title title="'+elem.warddesc+'">'+elem.warddesc+'</title><table><tr><td>'+$g('编制床位')+'：</td><td>'+elem.totalBeds+'</td></tr><tr><td>'+$g('已占用')+'：</td><td>'+elem.occupied+'</td></tr><tr><td>'+$g('今出/明出人数')+'：</td><td>'+elem.leavePatients+'</td></tr><tr><td>'+$g('床位使用率')+'：</td><td>'+elem.BedRate+'</td></tr><tr><td colspan="2" class="floor"><span>'+$g('位置')+'：</span><span class="mytooltip" title="'+LocFloor+'">'+LocFloor+'</span></td></tr></table></div></div>';
				$.extend(elem,{
					LocFloorDesc:LocFloor
				});
				filterData.push(elem);
			}
		})
	}else if (DisplayType =="2") { // 按楼展示
		var LocFloorArr=[];
		wardsData.map(function(elem) {
			var LocFloorId=elem.LocFloorId.split("||")[0];
			if (LocFloorId) { //&&(elem.LocFloorId.includes(LocBuildingFloor))
				if (((elem.warddesc.includes(wardName))||(elem.LocContactName.includes(wardName)))&&(((!LocBuilding)||(LocBuilding)&&(LocBuilding.indexOf("^"+elem.LocFloorId.split("||")[0]+"^")>=0)))) {
					var index=$.hisui.indexOfArray(LocFloorArr,"LocFloorId",LocFloorId);
					if (index>=0) {
						LocFloorArr[index].wardData.push(elem);
					}else{
						LocFloorArr.push({
							LocFloorId:LocFloorId,
							LocFloorDesc:elem.CTLBDesc,
							wardData:[elem]
						});
					}
				}
			}
		})
		LocFloorArr.map(function(elem) {
			str1+='<div class="building-div">'+elem.LocFloorDesc+'</div>';
			filterData.push({
				LocFloorId:elem.LocFloorId,
				warddesc:elem.LocFloorDesc,
				totalBeds:"",
				occupied:"",
				leavePatients:"",
				LocFloorDesc:""
			});
			elem.wardData = elem.wardData.sort(compare("LocFloorId"));
			var totalBedsTotal=0,occupiedTotal=0,leavePatientsTotal=0,nextLeavePatientsTotal=0;
			elem.wardData.map(function(elem1) {
				str1+='<div class="ihsWard"><div data-wardid="'+elem1.wardId+'"><title title="'+elem1.warddesc+'">'+elem1.warddesc+'</title><table><tr><td>'+$g("编制床位")+'：</td><td>'+elem1.totalBeds+'</td></tr><tr><td>'+$g("已占用")+'：</td><td>'+elem1.occupied+'</td></tr><tr><td>'+$g("今出/明出人数")+'：</td><td>'+elem1.leavePatients+'</td></tr><tr><td>'+$g("床位使用率")+'：</td><td>'+elem1.BedRate+'</td></tr><tr><td colspan="2" class="floor"><span>'+$g("位置")+'：</span><span class="mytooltip" title="'+elem1.CTLBDesc+'-'+elem1.CTLBFFloor+'">'+elem1.CTLBDesc+'-'+elem1.CTLBFFloor+'</span></td></tr></table></div></div>';
				$.extend(elem1,{
					LocFloorDesc:elem1.CTLBDesc+'-'+elem1.CTLBFFloor
				});
				filterData.push(elem1);
				totalBedsTotal += parseInt(elem1.totalBeds);
				occupiedTotal += parseInt(elem1.occupied);
				leavePatientsTotal += parseInt(elem1.leavePatients.split("/")[0]);
				nextLeavePatientsTotal += parseInt(elem1.leavePatients.split("/")[1]);
			})
			var index=$.hisui.indexOfArray(filterData,"LocFloorId",elem.LocFloorId);
			if (index >=0) {
				$.extend(filterData[index],{
					totalBeds:totalBedsTotal,
					occupied:occupiedTotal,
					leavePatients:leavePatientsTotal+"/"+nextLeavePatientsTotal,
					BedRate:totalBedsTotal>0?((occupiedTotal/totalBedsTotal*100).toFixed(2)+"%"):"0.00%"
				});
			}
		})
	}else if(DisplayType =="3"){ //按层展示(按层的描述)
		var LocFloorArr=[];
		wardsData.map(function(elem) {
			var CTLBFFloor=elem.CTLBFFloor;
			if (CTLBFFloor) { //&&(elem.LocFloorId.includes(LocBuildingFloor))
				if (((elem.warddesc.includes(wardName))||(elem.LocContactName.includes(wardName)))&&(((!LocBuilding)||(LocBuilding)&&(LocBuilding.indexOf("^"+elem.LocFloorId.split("||")[0]+"^")>=0)))) {
					var index=$.hisui.indexOfArray(LocFloorArr,"LocFloorDesc",CTLBFFloor);
					if (index>=0) {
						LocFloorArr[index].wardData.push(elem);
					}else{
						LocFloorArr.push({
							LocFloorId:elem.LocFloorId,
							LocFloorDesc:elem.CTLBFFloor,
							wardData:[elem]
						});
					}
				}
			}
		})
		LocFloorArr.map(function(elem) {
			str1+='<div class="floor-div">';
			str1+='<div class="floor-title"><span>'+elem.LocFloorDesc+'</span></div>';
			str1+='<div class="" style="position:relative;left:45px;">';
			filterData.push({
				LocFloorId:elem.LocFloorId,
				warddesc:elem.LocFloorDesc,
				totalBeds:"",
				occupied:"",
				leavePatients:"",
				LocFloorDesc:""
			});
			elem.wardData = elem.wardData.sort(compare("LocFloorId"));
			var totalBedsTotal=0,occupiedTotal=0,leavePatientsTotal=0,nextLeavePatientsTotal=0;
			elem.wardData.map(function(elem1) {
				str1+='<div class="ihsWard"><div data-wardid="'+elem1.wardId+'"><title title="'+elem1.warddesc+'">'+elem1.warddesc+'</title><table><tr><td>'+$g('编制床位')+'：</td><td>'+elem1.totalBeds+'</td></tr><tr><td>'+$g('已占用')+'：</td><td>'+elem1.occupied+'</td></tr><tr><td>'+$g('今出/明出人数')+'：</td><td>'+elem1.leavePatients+'</td></tr><tr><td>'+$g('床位使用率')+'：</td><td>'+elem1.BedRate+'</td></tr><tr><td colspan="2" class="floor"><span>'+$g('位置')+'：</span><span class="mytooltip" title="'+elem1.CTLBDesc+'-'+elem1.CTLBFFloor+'">'+elem1.CTLBDesc+'-'+elem1.CTLBFFloor+'</span></td></tr></table></div></div>';
				$.extend(elem1,{
					LocFloorDesc:elem1.CTLBDesc+'-'+elem1.CTLBFFloor
				});
				filterData.push(elem1);
				totalBedsTotal += parseInt(elem1.totalBeds);
				occupiedTotal += parseInt(elem1.occupied);
				leavePatientsTotal += parseInt(elem1.leavePatients.split("/")[0]);
				nextLeavePatientsTotal += parseInt(elem1.leavePatients.split("/")[1]);
			})
			var index=$.hisui.indexOfArray(filterData,"LocFloorId",elem.LocFloorId);
			if (index >=0) {
				$.extend(filterData[index],{
					totalBeds:totalBedsTotal,
					occupied:occupiedTotal,
					leavePatients:leavePatientsTotal+"/"+nextLeavePatientsTotal,
					BedRate:totalBedsTotal>0?((occupiedTotal/totalBedsTotal*100).toFixed(2)+"%"):"0.00%"
				});
			}
			str1+='</div></div>';
		})
	}
	$("#ihsWards").css({height:$("#ihsTab").height()-60}).html(str1);
  	$('#ihsWardsTable').datagrid({
    	width:$("#ihsTab").width()-2,
    	height:$("#ihsTab").height()-90,
		data: filterData,
		rowStyler: function(index,row){
			if (!row.wardId){
				return 'background:#D8EFFF;font-weight:bold;';
			}
		},
		onDblClickHeader:function(){
			window.open("websys.query.customisecolumn.csp?CONTEXT=KNur.NIS.Service.Base.Bed:GetWardBedsAndLeaveHospData&PAGENAME=InhospitalService&PREFID=0");
		}
	});
	setTimeout(function(){
		//mytooltip
		var newtitle = '';
        $('span.mytooltip,.ihsWard title').mouseover(function (e) {
            newtitle = this.title;
            this.title = '';
            if(newtitle != ''){
                $('body').append('<div id="mytitle" >' + newtitle + '</div>');
            }
            $('#mytitle').css({
                'left': (e.pageX + 'px'),
                'top': (e.pageY + 'px')
            }).show();
        }).mouseout(function () {
            this.title = newtitle;
            $('#mytitle').remove();
        }).mousemove(function (e) {
            $('#mytitle').css({
                'left': (e.pageX +10 + 'px'),
                'top': (e.pageY - 30+ 'px')
            }).show();
        })
		

		var displayTypeId=$(".displayType_sel")[0].id;
  		if (displayTypeId =="displayType_card") {
	  		ihsWardsShow(true);
	  	}else{
		  	ihsWardsShow(false);
		}
		//$("#ihsWards").show().next('div.panel').hide();
		$(".ihsWard>div").click(function(event) {
			$(".ihsWard>div.select").removeClass('select');
			$(this).addClass('select');
		});
		$(".ihsWard>div").dblclick(function(event) {
			window.open("dhc.nurse.vue.nis.csp?pageName=bedChart&bedOperation=N&wardID="+$(this).data('wardid'),'_blank');
		});
	},50);
}
function SortTypeChange(type){
	$(".menu-sel").removeClass("menu-sel");
	$("#SortType_"+type).addClass("menu-sel");
	SortType=type;
	filterWardsData();
}
function openBedChart(index,row) {
	window.open("dhc.nurse.vue.nis.csp?pageName=bedChart&wardID="+row.wardId,'_blank');
}
function InitLocBuilding(){
	$cm({
    	ClassName: 'Nur.InService.AppointManage',
    	QueryName: 'GetCTLocBuildList',
    	rows:99999,
		code:"",
		desc:"",
		hospid:hospID
  	},function (data) {
	  	var newData=new Array();
		for (var i=0;i<data.total;i++){
			var obj=data.rows[i];
			if (data.rows[i].CTLBDateFrom){
				if (myparser(data.rows[i].CTLBDateFrom)>myparser("")) continue;
			}
			if (data.rows[i].CTLBDateTo) {
				if (myparser(data.rows[i].CTLBDateTo)<=myparser("")) continue;
			}
			newData.push({
				id:data.rows[i].CTLBRowId,
				text:data.rows[i].CTLBDesc
			});
		}
  		$("#LocBuilding").keywords({
	  		singleSelect:false,
		    items:newData,
		    onSelect:function(v){
			    filterWardsData();
			},
			onUnselect:function(v){
				filterWardsData();
			}
		});
  	});
	
	/*$("#LocBuilding").combobox({
		url:$URL+"?ClassName=web.DHCBL.CT.CTLocBuilding&QueryName=GetList&rows=99999&ResultSetType=array",
		mode:'remote',
		method:"Get",
		multiple:false,
		selectOnNavigation:true,
		valueField:'CTLBRowId',
		textField:'CTLBDesc',
		onBeforeLoad:function(param){
			param.rowid="";
			param.code="";
			param.desc=param["q"];
			param.hospid="" //hospID;
		},
		onSelect:function(rec){
			filterWardsData();
			//$("#LocBuildingFloor").combobox("setValue","").combobox("reload");
		},
		onChange:function(newValue, oldValue){
			if (!newValue) {
				filterWardsData();
				//$("#LocBuildingFloor").combobox("setValue","").combobox("reload");
			}
		},
		loadFilter:function(data){
			var newData=new Array();
			for (var i=0;i<data.length;i++){
				var obj=data[i];
				if (data[i].CTLBDateFrom){
					if (myparser(data[i].CTLBDateFrom)>myparser("")) continue;
				}
				if (data[i].CTLBDateTo) {
					if (myparser(data[i].CTLBDateTo)<=myparser("")) continue;
				}
				newData.push(obj);
			}
			return newData;
		}
	});*/
}
/*function InitLocBuildingFloor(){
	$("#LocBuildingFloor").combobox({
		url:$URL+"?ClassName=web.DHCBL.CT.CTLocBuildingFloor&QueryName=GetList&rows=99999&ResultSetType=array",
		mode:'remote',
		method:"Get",
		multiple:false,
		selectOnNavigation:true,
		valueField:'CTLBFRowId',
		textField:'CTLBFFloor',
		onBeforeLoad:function(param){
			param.parref=$("#LocBuilding").combobox("getValue");
			param.rowid="";
			param.desc=param["q"];
		},
		onSelect:function(rec){
			filterWardsData();
		},
		loadFilter:function(data){
			var newData=new Array();
			for (var i=0;i<data.length;i++){
				var obj=data[i];
				if (data[i].CTLBFDateFrom){
					if (myparser(data[i].CTLBFDateFrom)>myparser("")) continue;
				}
				if (data[i].CTLBFDateTo) {
					if (myparser(data[i].CTLBFDateTo)<=myparser("")) continue;
				}
				newData.push(obj);
			}
			return newData;
		},
		onChange:function(newValue, oldValue){
			if (!newValue) {
				filterWardsData();
			}
		}
	});
}*/
window.addEventListener("resize",function() {
	/*$('#ihsTab').tabs({
		width:window.innerWidth-20,
		height:window.innerHeight-20
	});*/
	$("#ihsWards").css({height:window.innerHeight-20-97})
  	$('#ihsWardsTable').datagrid('resize',{
    	width:window.innerWidth-20-2,
    	height:window.innerHeight-20-85
	});
	setTimeout(function(){
		if (!$("#ihsWards").css('display').includes('none')) {
			$("#ihsWards").next('div.panel').hide();
		}
	},50);
})
if (!Array.prototype.includes) {
    Array.prototype.includes = function(elem){
        if (this.indexOf(elem)<0) {
            return false;
        } else {
            return true;
        }
    }
}
if (!String.prototype.includes) {
    String.prototype.includes = function(elem){
        if (this.indexOf(elem)<0) {
            return false;
        } else {
            return true;
        }
    }
}
function myparser(s){
    if (!s) return new Date();
    if(dtseparator=="/"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function compare(property) {
	return function(firstobj, secondobj){
		var firstValue = firstobj[property];
		if (firstValue.indexOf("||")>=0) firstValue=firstValue.split("||")[1];
	    var secondValue = secondobj[property];
	    if (secondValue.indexOf("||")>=0) secondValue=secondValue.split("||")[1];
	    if ((firstValue)&&(secondValue)) {
		    return firstValue - secondValue ; //升序
	    }else{
		    return true;
	    }
	}
}
function ihsWardsShow(flag) {
    $(".displayType_sel").removeClass("displayType_sel");
  	if (flag) {
      	$("#displayType_card").addClass("displayType_sel");
    	$("#ihsWards").show().next('div.panel').hide();
  	} else {
      	$("#displayType_list").addClass("displayType_sel");
    	$("#ihsWards").hide().next('div.panel').show();
    	$('#ihsWardsTable').datagrid('resize',{
      		width:window.innerWidth-20-2,
      		height:window.innerHeight-20-85
    	});
  	}
}
function wardDescFormate(value,row,index){
	if (SortType ==1){
		return value;
	}else{
		if (row.wardId) {
			return "<span style='margin-left:10px;'>"+value+"</span>";
		}else{
			return value;
		}
	}
}
function exportWardBedData(){
	$cm({
		//localDir:"Self",
		//ResultSetTypeDo:"Export",
		ExcelName:session['LOGON.HOSPDESC']+"病区概览",
		PageName:"InhospitalService",
		ResultSetType:"ExcelPlugin",
    	ClassName: 'Nur.NIS.Service.Base.Bed',
    	QueryName: 'GetWardBedsAndLeaveHospData',
    	hospitalId: hospID,
    	rows:99999
  	}, false);
}