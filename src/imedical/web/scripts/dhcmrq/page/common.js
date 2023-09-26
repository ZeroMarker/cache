window.console = window.console || (function(){   
    var c = {}; c.log = c.warn = c.debug = c.info = c.error = c.time = c.dir = c.profile   
    = c.clear = c.exception = c.trace = c.assert = function(){};   
    return c;   
})();
$.extend( true, $.fn.dataTable.defaults, {
	destroy: true,
	lengthMenu: [ [5, 10, 25, 50, -1], [5, 10, 25, 50, "全部"] ],
	pageLength: 5,
    language: {"url": "../scripts/dhcmrq/datatable-1.10.12/datatables.zh-CN.json"}
} );
var startDate = '';//开始日期
var endDate = '';//结束日期
var mrVersionCode = '';//首页版本代码
function init(){
	  $("#startDate,#endDate").datetimepicker({
	     format: "yyyy-mm-dd",
	     autoclose: true,
	     todayBtn: true,
	     minView: 2,
	     startView:2,
	     language: 'zh-CN'
	  });
	  
	  var dateNow = new Date();
	  var year = dateNow.getFullYear();
	  var month = dateNow.getMonth();
	  
	  if(month==0){
		  month = 12;
		  year--;
	  }
	  
	  var lastDay = new Date(year,month,0).getDate();
	  
	  if(month<10) month = '0'+month;
	  //if(lastDay<10) lastDay = '0'+lastDay;
	  
	  $("#startDate").val(year+'-'+month+'-01');
	  $("#endDate").val(year+'-'+month+'-'+lastDay);
	  
	  var startDate = getQueryString("startDate");//开始日期
	  var endDate = getQueryString("endDate");//结束日期
	  var mrVersionCode = getQueryString('mrVersionCode');//首页版本代码
	  
	  $("#startDate").val('2015-01-01');
	  $("#endDate").val('2015-01-31');
	  //$('#mrVersionSelect').val('CODING')
	  
	  if(startDate) $("#startDate").val(startDate);
	  if(endDate) $("#endDate").val(endDate);
	  if(mrVersionCode) $("#mrVersionSelect").val(mrVersionCode);
	  
	$(document).bind("click",function(e){
      var target = $(e.target);
      if(target.closest("#searchBox").length != 0){
        $("#searchLi").addClass("open");
      }else{
      	$("#searchLi").removeClass("open");
      }
  })
}

function searchByCondition(){
	$('#loading').fadeIn();
	$(document).ajaxStop(function(){
		$('#loading').fadeOut(400);
	});
	//setTimeout(function(){
		var mrVersion = $('#mrVersionSelect').find('option:selected').text();
		$('.mrVersion').text(mrVersion);
	
		startDate = $("#startDate").val();//开始日期
		endDate = $("#endDate").val();//结束日期
		mrVersionCode = $('#mrVersionSelect').val();//首页版本代码
	
		if(startDate == endDate){
			$('.time_id').html(startDate);
		} else{
			$('.time_id').html(startDate+'~'+endDate);
		}
	
		setTimeout(function(){
			$("#searchLi").removeClass("open");
		}, 200)
		
		loadData();
	//	$('#loading').fadeOut(400);
	//}, 1000);
	
	//$('#loading').fadeIn();
}


function pieChart(chart,data,name){
	var pieOption = {
		backgroundColor:'#fff',
	    tooltip : {
	        trigger: 'item',
	        position:'bottom',
	        confine:true,
	        formatter: "{a} <br/>{b} : {c} ({d}%)"
	    },
	    series : [
	        {
	            name:name,
	            type:'pie',
	            radius : '55%',
	            center: ['50%', '50%'],
	            data:data.sort(function (a, b) { return a.value - b.value}),
	            //roseType: 'angle',
	            label: {
	                normal: {
	                    textStyle: {
	                        color: 'rgba(0, 0, 0, 0.8)'
	                    }
	                }
	            },
	            labelLine: {
	                normal: {
	                    lineStyle: {
	                        color: 'rgba(0, 0, 0, 0.3)'
	                    },
	                    smooth: 0.2,
	                    length: 10,
	                    length2: 20
	                }
	            },
	            itemStyle: {
	                normal: {
	                    //color: '#c23531',
	                    //shadowBlur: 200, //饼图阴影，IE11会报“意外地调用了方法或属性访问”的错误，所以暂不启用
	                    shadowColor: 'rgba(0, 0, 0, 0.5)'
	                }
	            }
	        }
	    ]
	};
	chart.setOption(pieOption);
	chart.resize();
}

function getCookie(name) {   
            var arr = document.cookie.match(new RegExp("(^| )" + name + "=([^;]*)(;|$)"));
            if (arr != null) return unescape(arr[2]); return null;
 }
 
function setCookie(name, value) {
            document.cookie = name + "=" + escape(value);
 }
 
//获取url中的参数
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}

//打开新页签
function addTab(title,url,id){
	if(parent.Ext){
    	var tabs = parent.Ext.getCmp('main-tabs');
    	var tabId = "tab_"+id;
    	var obj = parent.Ext.getCmp(tabId);
    	if (!obj){
    	    obj=tabs.add({
    	    	id:tabId,
            	title:title,
            	tabTip:title,
            	html:"<iframe height='100%' width='100%' src='" + url + "'/>",
            	closable:true
      		 })
    	}
    	obj.show();
	} else {
		parent.showNavTab(id, title, url, id, 'fa-heartbeat');
	}	
};

//数字翻页加载效果
function showNum(num,con){
	if (num) {
		if($.trim(num)=='') num=0;
		con.html('');
		var numArray = $.trim(num).split('');
		for (var i = 0; i < numArray.length; i++) {
			if (/\d/.test(numArray[i])) {
				con.append('<span class="cn n'+i+'"></span>');
				count(numArray[i],con.find('.n'+i));
			} else {
				con.append('<span class="cn symbol"><span class="n symbol">'+numArray[i]+'</span></span>');
			}

		}
	}
}
function count(n,container){
	var i=0;
	var timer = setInterval(function () {
		container.append('<span class="n">'+(i++)+'</span>');
		if (i>n) {
			clearInterval(timer);
		}
	}, 400);
}
$.fn.msg = function(type,msg){
	var icon = {
		info:'fa-info-circle',
		success:'fa-check-circle',
		danger:'fa-exclamation-circle'
	}
	var alert = $('<div class="alert alert-'+type+' alert-dismissible" role="alert">'
				+	'<button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>'
				+	'<i class="fa '+icon[type]+'"></i><span class="text">' + msg +'</span>'
				+'</div>');
	$(this).after(alert);
	setTimeout(function () {
		alert.fadeOut();
	}, 2000);
}

function msg (type,msg,time){
	var icon = {
		info:'fa-info-circle',
		success:'fa-check-circle',
		warning:'fa-exclamation-circle',
		danger:'fa-times-circle'
	}
	var alert = $('<div class="alert note-wt note-wt-'+type+' alert-dismissible" role="alert">'
				+	'<button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>'
				+	'<div class="note-wt-body"><i class="fa '+icon[type]+'"></i><span class="text">' + msg +'</span></div>'
				+'</div>');
	$('body').append(alert);
	
	if(time){
		setTimeout(function () {
			alert.fadeOut();
		}, time);	
	}
}

function getConf(confCode){
	var confValue;
	$.ajax({
	    type: 'POST',
	    async:false,
        url: 'dhcmrq.service.csp',
        data: {ClassName:'DHCMRQ.Base.Config',
			   MethodName:'GetValueByCode',
			   Params:confCode
		},
		success: function (data) {
			confValue = data;
	    }
	});
	return confValue;
}