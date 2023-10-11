var hospID,wardsData=[];
var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串  
var isOpera = userAgent.indexOf("Opera") > -1; //判断是否Opera浏览器  
var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera || userAgent.indexOf("rv:11") > -1; //判断是否IE浏览器 
var canvas = document.getElementById('colorPicker');
var ctx = canvas.getContext('2d');
var selected;
var arr = []; 
$(function() {
	hospComp = GenHospComp("Nur_IP_BPChartConfig",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		hospID=d.HOSPRowId;
		getBPConfigData();
	}
	getBPConfigData();
	$('input[type="color"]').click(function(e) {
	  e.stopPropagation();
		selected=$(this)[0];
		console.log(isIE);
		if (isIE) {
      $('#colorPicker').css({
        left: e.pageX,
        top: Math.min(e.clientY, window.innerHeight - 330) + "px"
      }).show();
		}
	});
})
function draw() {
	var w=5; //宽度是2
	var count=0
  var flag=false;
  var pos=[];
  var L=2*63*63;
	for (var x = 0; x < 64; x++) {
  	for (var y = 0; y < 64; y++) {
  		var b=x*x+y*y;
  		if (b) {
  			var alpha=(b+L-Math.pow(63-x,2)-Math.pow(63-y,2))/(2*Math.sqrt(b*L));
  		} else {
  			var alpha=1;
  		}
  		pos.push({
  			x:x,
  			y:y,
  			sort:alpha*Math.sqrt(b),
  		})
  	}
	}
	pos=pos.sort(function(a,b) {
		return a.sort-b.sort
	})
	count=0;
  var L=3*15*15;
  for (var i = 0; i < 16; i++) {
    for (var j = 0; j < 16; j++) {
      for (var k = 0; k < 16; k++) {
    		var b=i*i+j*j+k*k;
    		if (b) {
    			var alpha=(b+L-Math.pow(15-i,2)-Math.pow(15-j,2)-Math.pow(15-k,2))/(2*Math.sqrt(b*L));
    		} else {
    			var alpha=1;
    		}
        arr.push({
    			sort:alpha*Math.sqrt(b),
          // color: 'rgb(' + Math.floor(255 - 16 * i) + ',' + Math.floor(255 - 16 * j) + ',' + Math.floor(255 - 16 * k) + ')'
          color: '#' + hexadecimal(255 - 16 * i) + hexadecimal(255 - 16 * j) + hexadecimal(255 - 16 * k)
        });
        count++;
      }
    }
  }
	arr=arr.sort(function(a,b) {
		return a.sort-b.sort
	})
	pos.map(function(e,i) {
		arr[i].x1=e.x*w;
		arr[i].y1=e.y*w;
		arr[i].x2=e.x*w+w;
		arr[i].y2=e.y*w+w;
    ctx.fillStyle = arr[i].color;
    ctx.fillRect(e.x*w, e.y*w, w, w);
	})
}
draw();
function hexadecimal(val) {
	val=val.toString(16)
	val='0'+val
	return val.slice(-2);
}
canvas.addEventListener('click', function (e) {
	console.log(e);
  var x = e.offsetX;
  var y = e.offsetY;
  for (var i = 0; i < arr.length; i++) {
    if (x >= arr[i].x1
      && x < arr[i].x2
      && y >= arr[i].y1
      && y < arr[i].y2) {
      var color = arr[i].color;
      selected.style.backgroundColor = color;
      selected.value = color;
      // console.log(selected);
      // console.log(color);
			// var val=$(this).val().toUpperCase();
			// if ((7!=val.length)||(!val.match(/#[\dA-F]{6}/))) return;
			$(selected).css({
				// 'background-color':color,
				color:getContraryColor(color)
			})
    }
  }
  e.preventDefault();
  e.stopPropagation();
}, true);
document.addEventListener('click', function (e) {
	$('#colorPicker').hide();
})
function getBPConfigData() {
  $cm({
    ClassName: 'Nur.NIS.Service.VitalSign.BloodPressure',
    MethodName: 'GetBPConfig',
		hospDR:$HUI.combogrid('#_HospList').getValue()
  }, function (data) {
  	console.log(data);
		$("#sysPresColor").val(data.sysPresColor||'#000000');
		$("#diaPresColor").val(data.diaPresColor||'#000000');
		$("#bpMax").numberbox('setValue',formatData(data.bpMax));
		$("#id").val(data.id);
		$("#bpMin").numberbox('setValue',formatData(data.bpMin));
		$("#bpGap").numberbox('setValue',formatData(data.bpGap));
		$("#sysPresHigh").numberbox('setValue',formatData(data.sysPresHigh));
		$("#sysPresHighColor").val(data.sysPresHighColor||'#000000').css("backgroundColor",data.sysPresHighColor ? data.sysPresHighColor : "#fff")
		$("#sysPresLow").numberbox('setValue',formatData(data.sysPresLow));
		$("#sysPresLowColor").val(data.sysPresLowColor||'#000000').css("backgroundColor",data.sysPresLowColor ? data.sysPresLowColor : "#fff");
		$("#diaPresHigh").numberbox('setValue',formatData(data.diaPresHigh));;
		$("#diaPresHighColor").val(data.diaPresHighColor||'#000000').css("backgroundColor",data.diaPresHighColor ? data.diaPresHighColor : "#fff");
		$("#diaPresLow").numberbox('setValue',formatData(data.diaPresLow));
		$("#diaPresLowColor").val(data.diaPresLowColor||'#000000').css("backgroundColor",data.diaPresLowColor ? data.diaPresLowColor : "#fff");
		$("#presGapHigh").numberbox('setValue',formatData(data.presGapHigh));
		$("#presGapLow").numberbox('setValue',formatData(data.presGapLow));
		$("#period").combobox('setValue',data.period||'1');
		$('#bpForm').form('disableValidation')
  });
}
function formatData(d) {
	if ('undefined'==typeof d) return '';
	return parseFloat(d);
}
function saveBPConfig() {
	$('#bpForm').form('enableValidation')
	if (!$('#bpForm').form('validate')) return;
	var sysPresColor=$("#sysPresColor").val();
	var diaPresColor=$("#diaPresColor").val();
	var id=$("#id").val();
	var bpMax=$("#bpMax").numberbox('getValue');
	bpMax=parseFloat(bpMax);
	var bpMin=$("#bpMin").numberbox('getValue');
	bpMin=parseFloat(bpMin);
	if (bpMax<=bpMin) return $.messager.popover({msg: '最大值要大于最小值！',type:'alert'});
	var bpGap=$("#bpGap").numberbox('getValue');
	if (bpGap<=0) return $.messager.popover({msg: '间隔值要大于0！',type:'alert'});
	console.log(bpMax-bpMin);
	console.log(bpGap>(bpMax-bpMin));
	if (bpGap>(bpMax-bpMin)) return $.messager.popover({msg: '间隔值不能大于最大值和最小值的差值！',type:'alert'});
	var sysPresHigh=$("#sysPresHigh").numberbox('getValue');
	sysPresHigh=sysPresHigh?parseFloat(sysPresHigh):'';
	var sysPresHighColor=$("#sysPresHighColor").val();
	var sysPresLow=$("#sysPresLow").numberbox('getValue');
	sysPresLow=sysPresLow?parseFloat(sysPresLow):'';
	var sysPresLowColor=$("#sysPresLowColor").val();
	if (sysPresHigh&&sysPresLow&&(sysPresHigh<=sysPresLow)) return $.messager.popover({msg: '收缩压预警高值要大于收缩压预警低值！',type:'alert'});
	if (sysPresHigh&&(bpMax<sysPresHigh)) return $.messager.popover({msg: '最大值要不小于收缩压预警高值！',type:'alert'});
	if (sysPresLow&&(bpMin>sysPresLow)) return $.messager.popover({msg: '最小值要不大于收缩压预警低值！',type:'alert'});

	var diaPresHigh=$("#diaPresHigh").numberbox('getValue');
	diaPresHigh=diaPresHigh?parseFloat(diaPresHigh):'';
	var diaPresHighColor=$("#diaPresHighColor").val();
	var diaPresLow=$("#diaPresLow").numberbox('getValue');
	diaPresLow=diaPresLow?parseFloat(diaPresLow):'';
	var diaPresLowColor=$("#diaPresLowColor").val();
	if (diaPresHigh&&diaPresLow&&(diaPresHigh<=diaPresLow)) return $.messager.popover({msg: '舒张压预警高值要大于舒张压预警低值！',type:'alert'});
	if (diaPresHigh&&(bpMax<diaPresHigh)) return $.messager.popover({msg: '最大值要不小于舒张压预警高值！',type:'alert'});
	if (diaPresLow&&(bpMin>diaPresLow)) return $.messager.popover({msg: '最小值要不大于舒张压预警低值！',type:'alert'});
	var presGapHigh=$("#presGapHigh").numberbox('getValue');
	var presGapLow=$("#presGapLow").numberbox('getValue');
	if (presGapHigh&&presGapLow&&(presGapHigh<=presGapLow)) return $.messager.popover({msg: '脉压差预警高值要大于脉压差预警低值！',type:'alert'});
	var period=$("#period").combobox('getValue');
	var data={
		sysPresColor:sysPresColor,
		diaPresColor:diaPresColor,
		bpMax:bpMax,
		id:id,
		bpMin:bpMin,
		bpGap:bpGap,
		sysPresHigh:sysPresHigh,
		sysPresHighColor:sysPresHighColor,
		sysPresLow:sysPresLow,
		sysPresLowColor:sysPresLowColor,
		diaPresHigh:diaPresHigh,
		diaPresHighColor:diaPresHighColor,
		diaPresLow:diaPresLow,
		diaPresLowColor:diaPresLowColor,
		presGapHigh:presGapHigh,
		presGapLow:presGapLow,
		period:period,
		hospDR:$HUI.combogrid('#_HospList').getValue()
	}
  var res=$cm({
    ClassName: 'Nur.NIS.Service.VitalSign.BloodPressure',
    MethodName: 'AddOrUpdateBPConfig',
    dataType: "text",
    data:JSON.stringify(data)
  }, false);
	console.log(res);
	if (res>=0) {
		$.messager.popover({msg: '保存成功！',type:'success'});
		if (res>0) $("#id").val(res);
	} else {
		$.messager.popover({msg: res,type:'alert'});
	}
}
// 手填颜色
function handFillingColor() {
	$(".handFilling").hide().prev().css({
		'background-color':$("#color").val(),
		color:getContraryColor($("#color").val())
	}).attr('type', 'text').keyup(function(event) {
		console.log(arguments);
		console.log($(this).val());
		var val=$(this).val().toUpperCase();
		if ((7!=val.length)||(!val.match(/#[\dA-F]{6}/))) return;
		$(this).css({
			'background-color':$(this).val(),
			color:getContraryColor(val)
		})
	});
}
// 获取相反的颜色
function getContraryColor(val) {
	if (!val) val="#ffffff";
	var color="#";
	for (var i = 1; i < val.length; i=i+2) {
		var s='0'+(255-parseInt(val.slice(i,i+2),16)).toString(16);
		color+=s.slice(-2);
	}
	return color;
}
function resizeTableHeight() {
	var innerHeight=window.innerHeight;
  $('#bpPanel').panel('resize', {
  	height:innerHeight-65
  }); 
}
setTimeout(resizeTableHeight,100);
window.addEventListener("resize",resizeTableHeight);
