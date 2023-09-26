// underscore 防抖
function debounce(func, wait, immediate) {
    var timeout, result;
    var debounced = function () {
        var context = this;
        var args = arguments;

        if (timeout) clearTimeout(timeout);
        if (immediate) {
            // 如果已经执行过，不再执行
            var callNow = !timeout;
            timeout = setTimeout(function(){
                timeout = null;
            }, wait)
            if (callNow) result = func.apply(context, args)
        }
        else {
            timeout = setTimeout(function(){
                func.apply(context, args)
            }, wait);
        }
        return result;
    };
    debounced.cancel = function() {
        clearTimeout(timeout);
        timeout = null;
    };
    return debounced;
}
var initBase=function(){
	GV.base={
		getValue:function(){
			var stObj=$('#dt-from');
			var endObj=$('#dt-to');
			var ftObj=$('#fire-times');
			var obj={
				st:stObj.datetimebox('getValue'),
				end:endObj.datetimebox('getValue'),
				ft:ftObj.numberbox('getValue')
			}
			return obj;
		},setValue:function(obj){
			var stObj=$('#dt-from');
			var endObj=$('#dt-to');
			var ftObj=$('#fire-times');
			stObj.datetimebox('setValue',obj.st||''),
			endObj.datetimebox('setValue',obj.end||''),
			ftObj.numberbox('setValue',obj.ft||'')
		}	
	}
	$('#dt-from').datetimebox({
		onChange:function(){
			commonLimitChange();
		}	
	});
	$('#dt-to').datetimebox({
		onChange:function(){
			commonLimitChange();
		}	
	});
	$('#fire-times').numberbox('options').onChange=function(){
		commonLimitChange();
	}
	var commonLimitChange=debounce(function(){
		var tab=$('#tt').tabs('getSelected');
		var tabid=tab.attr('id');
		if(GV[tabid].commonLimitChange){
			GV[tabid].commonLimitChange();
		}
	},200);
	
	$('#tt').tabs('options').onSelect=function(ind){
		var tab=$('#tt').tabs('getTab',ind);
		var tabid=tab.attr('id');
		if(GV[tabid].commonLimitChange){
			GV[tabid].commonLimitChange();
		}
	}
}
var initTab1=function(){
	var formTable=$('#tab1').find('.form-table');
	for (var i=1;i<=5;i++){
		formTable.append('<tr>\
						<td class="r-label">时间'+i+'</td>\
						<td><input class="t1-datetime hisui-datetimebox" data-options="width:200,showSeconds:false"  /></td>\
					</tr>')
	}
	$.parser.parse(formTable);
	
	GV.tab1={
		getValue:function(){
			var obj=GV.base.getValue();
			var dtArr=[];
			$('#tab1').find('.t1-datetime').each(function(){
				var dt=$(this).datetimebox('getValue');
				if (dt) dtArr.push(dt);
			})
			obj.dtArr=dtArr;
			return obj;
		},setValue:function(obj){
			GV.base.setValue(obj);
			$('#tab1').find('.t1-datetime').each(function(ind){
				$(this).datetimebox('setValue',obj.dtArr[ind]);
			})
		}	
	}
}
var initTab2=function(){
	GV.tab2={
		getValue:function(){
			var obj=GV.base.getValue();
			var day=$('#tab2').find('.day').numberbox('getValue');
			var hour=$('#tab2').find('.hour').numberbox('getValue');
			var minute=$('#tab2').find('.minute').numberbox('getValue');
			var seconds=(parseInt(day)||0)*86400+(parseInt(hour)||0)*3600+(parseInt(minute)||0)*60;
			obj.itv=seconds;
			if (!obj.st) {
				obj.errmsg=	'请选择开始时间'
			}
			if (!(obj.itv>0)) {
				obj.errmsg=	'请输入发送频率'
			}
			return obj;
			
		},setValue:function(obj){
			GV.base.setValue(obj);
			var itv=(parseInt(obj.itv)||0);
			var day=Math.floor( itv/86400 );
			itv=itv-day*86400;
			var hour=Math.floor( itv/3600 );
			itv=itv-hour*3600;
			var minute=Math.floor( itv/60 );
			itv=itv-minute*60;
			$('#tab2').find('.day').numberbox('setValue',day);
			$('#tab2').find('.hour').numberbox('setValue',hour);
			$('#tab2').find('.minute').numberbox('setValue',minute);
		}	
	}
}


function addAppointList(type,target,min,max,num,labelMap){
	labelMap=labelMap||{};
	var appointRow;
	for (var i=min,cnt=0;i<=max;i++,cnt++) {
		var label=labelMap[i]||((i<10?'0':'')+''+i);
		if (cnt%num==0) appointRow=$('<tr></tr>').appendTo(target);
		$('<td><input type="checkbox" class="cron-appoint-checkbox " label="'+label+'" value="'+i+'" id="'+type+'-appoint-ck'+i+'" /></td>').appendTo(appointRow);
	}
}
function addCronItem(type,desc,min,max,num,arr,note,labelMap,disabled){
		var spinnerwidth=max>1000?70:60
		var $con=$('#cron-'+type);
		if (note)$con.append('<div class="cron-line"><span style="">'+note+'</span></div>')
		if (arr.indexOf('every')>-1) {
			$con.append('<div class="cron-line">\
				<input id="radio-'+type+'-every" name="radio-'+type+'" class="cron-radio" type="radio" value="every" />\
				<span style="">每'+desc+'</span>\
			</div>');
		}
		if (arr.indexOf('nopoint')>-1) {
			$con.append('<div class="cron-line">\
				<input id="radio-'+type+'-nopoint" name="radio-'+type+'" class="cron-radio" type="radio" value="nopoint" />\
				<span style="">不指定</span>\
			</div>');
		}
		if (arr.indexOf('cycle')>-1) {
			$con.append('<div class="cron-line">\
				<input id="radio-'+type+'-cycle" name="radio-'+type+'" class="cron-radio" type="radio" value="cycle" />\
				<span>周期从</span>\
				<input class="cycle-start cron-numberspinner" data-options="min:'+min+',max:'+max+',width:'+spinnerwidth+',height:24,value:'+min+'"/>\
				<span>-</span>\
				<input class="cycle-end cron-numberspinner" data-options="min:'+min+',max:'+max+',width:'+spinnerwidth+',height:24,value:'+min+'"/>\
				<span>'+desc+'</span>\
			</div>');
		}
		if (arr.indexOf('inc')>-1) {
			$con.append('<div class="cron-line">\
				<input id="radio-'+type+'-inc" name="radio-'+type+'" class="cron-radio" type="radio" value="inc" />\
				<span>从</span>\
				<input class="inc-start cron-numberspinner" data-options="min:'+min+',max:'+max+',width:'+spinnerwidth+',height:24,value:'+min+'"/>\
				<span>'+desc+'开始,每</span>\
				<input class="inc-inc cron-numberspinner" data-options="min:1,max:'+max+',width:'+spinnerwidth+',height:24,value:1"/>\
				<span>'+desc+'执行一次</span>\
			</div>');
		}
		if (arr.indexOf('appoint')>-1) {
			$con.append('<div class="cron-line">\
				<input id="radio-'+type+'-appoint" name="radio-'+type+'" class="cron-radio" type="radio" value="appoint" />\
				<span>指定</span>\
				<table class="appoint-table" id="appoint-table-'+type+'"></table>\
			</div>');
			addAppointList(type, $('#appoint-table-'+type),min,max,num,labelMap);
		}

		$.parser.parse($con[0]);
		
		if(disabled){
			$con.css('position','relative');
			$con.append('<div class="window-mask cron-disabled" style="width: 100%; height: 100%; display: block; z-index: 10003;"></div>')
		}
}

var initTab4=function(){
	var currCron={
		s:0,
		m:0,
		h:0,
		dom:'*',
		mon:'*',
		dow:'?',
		y:'*'
	}
	var typeArr=['s','m','h','dom','mon','dow','y']
	//,['every','nopoint','cycle','inc','appoint']
	addCronItem('s','秒',0,59,15,['every','cycle','inc','appoint'],'','',true);
	addCronItem('m','分钟',0,59,15,['every','cycle','inc','appoint']);
	addCronItem('h','小时',0,23,12,['every','cycle','inc','appoint']);
	addCronItem('dom','日',1,31,16,['every','nopoint','cycle','inc','appoint']);
	addCronItem('mon','月',1,12,12,['every','cycle','inc','appoint']);
	addCronItem('dow','周',1,7,7,['nopoint','appoint'],'',{1:'周日',2:'周一',3:'周二',4:'周三',5:'周四',6:'周五',7:'周六'});
	addCronItem('y','年',1970,2099,10,['every','cycle','inc','appoint']);
	$('#cron').tabs('select',1)
	
	
	function radioClick(radio){
		var id=radio.attr('id');
		var type=id.split("-")[1],type2=id.split("-")[2];
		var codeLine=radio.closest('.cron-line');
		
		var value=""
		if(type2=='every'){
			value="*"
		}else if(type2=='nopoint'){
			value="?"
		}else if(type2=='cycle'){ //周期
			var stObj=codeLine.find('.cycle-start');
				endObj=codeLine.find('.cycle-end');
			var st=stObj.numberspinner('getValue');
				end=endObj.numberspinner('getValue');
			value=st+'-'+end;
			
		}else if(type2=='inc'){
			var stObj=codeLine.find('.inc-start');
				incObj=codeLine.find('.inc-inc');
			var st=stObj.numberspinner('getValue');
				inc=incObj.numberspinner('getValue');
			value=st+'/'+inc;
		}else if(type2=='appoint'){
			var arr=[];
			codeLine.find('.cron-appoint-checkbox').each(function(){
				if($(this).checkbox('getValue')){
					arr.push( $(this).attr('value') );
				}	
			})
			value=arr.join(',')
		}
		currCron[type]=value;
		updateCronExp();
	}
	
	function updateCronExp(){
		var arr=[];
		for(var i=0;i<typeArr.length;i++){
			arr.push(currCron[typeArr[i]]);	
		}
		var cronExp=arr.join(' ');
		$('#tab4').find('.cronexp').val(cronExp)
		///BSP.SYS.COM.CronExpression
		/*$.m({ClassName:'BSP.SYS.COM.CronExpression',MethodName:'GetNextFireTimes',str:cronExp,num:5},function(ret){
			if(ret.substr(0,2)=='-1'){
				//$.messager.alert('提示','cron表达式错误<br>'+ret.split('^')[1],'warning');
				$('#tab4').find('.cronexp-fire-5').addClass('validatebox-invalid').val(ret.split('^')[1]);
			}else{
				var ret=$.parseJSON(ret);
				$('#tab4').find('.cronexp-fire-5').removeClass('validatebox-invalid').val(ret.join(' '));
			}
		})*/
		refreshNext5FireTimes();
	}
	function refreshNext5FireTimes(){
		$('#tab4').find('.cronexp-fire-5').removeClass('validatebox-invalid').val('');
		var obj=GV.tab4.getValue();
		//GetNextNumFireTimes(DateFrom = "", TimeFrom = "", DateTo = "", TimeTo = "", PlanFireTimes = "", FireAtListStr = "", FireInterval = "", CronExp = "", num = 5)
		$.m({ClassName:'BSP.MSG.BL.Task',MethodName:'GetNextNumFireTimes',
			DateFrom:obj.st.split(' ')[0]||'',
			TimeFrom:obj.st.split(' ')[1]||'',
			DateTo:obj.end.split(' ')[0]||'',
			TimeTo:obj.end.split(' ')[1]||'',
			PlanFireTimes:obj.ft,
			CronExp:$('#tab4').find('.cronexp').val(),
			num:5
		},function(ret){
			if(ret.substr(0,2)=='-1'){
				//$.messager.alert('提示','cron表达式错误<br>'+ret.split('^')[1],'warning');
				$('#tab4').find('.cronexp-fire-5').addClass('validatebox-invalid').val(ret.split('^')[1]);
			}else{
				var ret=$.parseJSON(ret);
				$('#tab4').find('.cronexp-fire-5').removeClass('validatebox-invalid').val(ret.join(' '));
			}
		})
	}
	
	var debounce_radioClick=debounce(radioClick,200);
	
	$('.cron-radio').each(function(){
		var t=$(this);
		t.radio({onChecked:function(){
			debounce_radioClick(t);
		}})	
	})

	
	$('.cron-numberspinner').each(function(){
		var t=$(this);
		t.numberspinner({onChange:function(){
			var radio=t.closest('.cron-line').find('.cron-radio');
			radio.radio('check');
			debounce_radioClick(radio)
		}})
	})
	
	$('.cron-appoint-checkbox').each(function(){
		var t=$(this);
		t.checkbox({onCheckChange:function(){
			var radio=t.closest('.cron-line').find('.cron-radio');
			radio.radio('check');
			debounce_radioClick(radio)
		}})
	})
	function parseCronExp(cron){
		var cronArr=cron.split(' ');
		for(var i=0;i<typeArr.length;i++){
			var value=cronArr[i],type=typeArr[i];
			if(value=='*') {
				$('#radio-'+type+'-every').radio('check');
			}else if(value=='?') {
				$('#radio-'+type+'-nopoint').radio('check');
			}else if(value.indexOf('-')>-1) {
				
				$('#radio-'+type+'-cycle').radio('check');
				var st=parseInt(value.split('-')[0])||0,
					end=parseInt(value.split('-')[1])||0;
				$('#radio-'+type+'-cycle').closest('.code-line').find('.cycle-start').numberspinner('setValue',st);
				$('#radio-'+type+'-cycle').closest('.code-line').find('.cycle-end').numberspinner('setValue',end);
				
			}else if(value.indexOf('/')>-1) {
				$('#radio-'+type+'-inc').radio('check');
				var st=parseInt(value.split('/')[0])||0,
					inc=parseInt(value.split('/')[1])||0;
				$('#radio-'+type+'-inc').closest('.code-line').find('.inc-start').numberspinner('setValue',st);
				$('#radio-'+type+'-inc').closest('.code-line').find('.inc-end').numberspinner('setValue',inc);
				
			}else{
				$('#radio-'+type+'-appoint').radio('check');
				var arr=value.split(',')
				for (var j=0;j<arr.length;j++){
					$('#'+type+'-appoint-ck'+value[j]).checkbox('check');
				}
			}
			currCron[type]=value
		}
		
	}
	GV.tab4={
		getValue:function(){
			var obj=GV.base.getValue();
			var cron=$('#tab4').find('.cronexp').val();
			if ($('#tab4').find('.cronexp-fire-5').hasClass('validatebox-invalid')){
				obj.errmsg=	$('#tab4').find('.cronexp-fire-5').val();
			}
			obj.cron=cron
			return obj;
		},setValue:function(obj){
			GV.base.setValue(obj);
			var cron=obj.cron;
			parseCronExp(cron);
		},
		commonLimitChange:function(){
			refreshNext5FireTimes();
		}	
	}
}

function timeSecond2Alias(seconds){
	var itv=parseInt(seconds)||0;
	var day=Math.floor( itv/86400 );
	itv=itv-day*86400;
	var hour=Math.floor( itv/3600 );
	itv=itv-hour*3600;
	var minute=Math.floor( itv/60 );
	itv=itv-minute*60;
	
	var ret='';
	if (day>0) ret+=day+'天';
	if(hour>0 || day>0) ret+=hour+'小时';
	if(minute>0 || day>0 ||hour>0) ret+=minute+'分钟';
	return ret;
	
}

$(function(){
	initBase();
	initTab1();
	initTab2();
	initTab4();
	GV.getValue=function(){
		var tab=$('#tt').tabs('getSelected');
		var tabid=tab.attr('id');
		var obj=GV[tabid].getValue();
		console.log(obj);
		if (obj.errmsg){
			$.messager.alert('提示',obj.errmsg,'error');
			return '';	
		}
		var arr=[];
		arr.push(obj.st||'');
		arr.push(obj.end||'');
		arr.push(obj.ft||'');
		arr.push((obj.dtArr||[]).join('|'));
		arr.push(obj.itv||'');
		arr.push(obj.cron);
		var str=arr.join('^');
		//console.log(str);
		return str;
	}
	GV.setValue=function(str){
		var arr=str.split('^'),obj={};
		obj.st=arr[0];
		obj.end=arr[1];
		obj.ft=arr[2];
		obj.dtArr=arr[3]?arr[3].split('|'):[]
		obj.itv=arr[4];
		obj.cron=arr[5];
		
		var tabid='tab1'
		if(obj.itv>0){
			tabid='tab2'	
		}else if(obj.cron){
			tabid='tab4';
		}
		var tab=$('#'+tabid);
		var tabindex=$('#tt').tabs('getTabIndex',tab);
		$('#tt').tabs('select',tabindex);
		GV[tabid].setValue(obj);
		if (tabid!='tab4'){
			obj.cron='0 0 0 * * ? *'
			GV['tab4'].setValue(obj);
		}
	}
	
	GV.setValue(GV.reqExp);
	
	$('#ok').click(function(){
		var str=GV.getValue();
		var strText='',arr=str.split('^');
		if (arr[0]) strText+='从'+arr[0]+'起，';
		if (arr[3]){ strText+='在【'+arr[3]+'】发送';}
		else if (arr[4]) {strText+='每隔【'+timeSecond2Alias(arr[4])+'】发送';}
		else if (arr[5]) {strText+='以Cron表达式【'+arr[5]+'】发送';}
		if (arr[1]) strText+='，直至'+arr[1]+'';
		if (arr[2]) strText+='，最多发送'+arr[2]+'次';
		
		if (str){
			//在点确定就进行校验
			//GetNextNumFireTimes(DateFrom = "", TimeFrom = "", DateTo = "", TimeTo = "", PlanFireTimes = "", FireAtListStr = "", FireInterval = "", CronExp = "", num = 5)
			$.m({ClassName:'BSP.MSG.BL.Task',MethodName:'GetNextNumFireTimes',
				DateFrom:arr[0].split(' ')[0]||'',
				TimeFrom:arr[0].split(' ')[1]||'',
				DateTo:arr[1].split(' ')[0]||'',
				TimeTo:arr[1].split(' ')[1]||'',
				PlanFireTimes:arr[2],
				FireAtListStr:arr[3],
				FireInterval:arr[4],
				CronExp:arr[5],
				num:1
			},function(ret){
				if(ret.substr(0,2)=='-1'){
					$.messager.popover({msg:ret.split('^')[1],type:'error'});
				}else{
					var ret=$.parseJSON(ret);
					callParent({act:'ok',exp:str,expText:strText});
				}
			})
		}
		
	})
	$('#close').click(function(){
		callParent({act:'close'});
	})
	function callParent(data){
		if (GV.parJsFun && typeof parent.window[GV.parJsFun]=='function') {
			parent.window[GV.parJsFun](data);
		}
	}
	
})