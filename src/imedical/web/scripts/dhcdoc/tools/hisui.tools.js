(function($){
    $.extend($.fn.combobox.defaults, {  
        valueField:'id',
        textField:'text', 
        panelHeight:200, 
        mode:"local",
        url:'DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Combo',
        filter: function(q, row){
            var opts = $(this).combobox('options');
            return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
        },
        onLoadError:function(){
            debugger;
            $.messager.alert('提示','初始化下拉框失败!','error');
        }
    });
    $.extend($.fn.combobox.methods, {
        select:function(jq,value){
            return jq.each(function(){
                $(this).combobox('setValue',value);
                var opts=$(this).combobox('options');
                var valueField=opts.valueField;
                var data=$(this).combobox('getData');
                for(var i=0;i<data.length;i++){
                    if(data[i][valueField]==value){
                        opts.onSelect.call(this,data[i]);
                        break;
                    }
                }
            });
        }
    });
    $.extend($.fn.combogrid.defaults, {
        idField:"id",
        textField:"text",
        mode:'remote',
        url:'DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Grid',
        onLoadError:function(){
            debugger;
            $.messager.alert('提示','表格初始化失败!','error');
        }
    });
    $.extend($.fn.tree.defaults, {    
        url:'DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Tree',
        onLoadError:function(){
            debugger;
            $.messager.alert('提示','初始化树失败','error');
        }
    });
    $.extend($.fn.treegrid.defaults, {
        idField:"id",
        treeField:"text",
        striped:true,
        fit:true,
        fitColumns:true,
        singleSelect:true,
        pagination:false,
        url:'DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Tree',
        onLoadError:function(){
            $.messager.alert('提示','初始化树表格失败','error');
        }
    }); 
    $.extend($.fn.datagrid.defaults, {    
        striped:true,
        fit:true,
        fitColumns:true,
        singleSelect:true,
        rownumbers:true,
        pagination:false,
        url:'DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Grid',
        onLoadError:function(){
            $.messager.alert('提示','表格初始化失败!','error');
        }
    });
    $.extend($.fn.datagrid.defaults.editors, {   
        textarea: {   
            init: function(container, options){   
                var input = $('<textarea class="datagrid-editable-input" rows='+options.rows+'></textarea>').appendTo(container);   
                return input;   
            },   
            getValue:function(target){   
                return $(target).val();   
            },   
            setValue:function(target, value){   
                $(target).val(value);   
            },   
            resize:function(target, width){   
                var input = $(target);   
                if ($.boxModel == true){   
                    input.width(width - (input.outerWidth() - input.width()));   
                } else {   
                    input.width(width);   
                }   
            }   
        }
    });
    $.extend($.fn.tabs.methods, {
        clearTabs: function(jq){    
            return jq.each(function(){    
                var SelectFun=$(this).tabs('options').onSelect;
                $(this).tabs('options').onSelect=function(){};
                var length=$(this).tabs('tabs').length;
                for(var i=length;i>0;i--){
                    $(this).tabs('close',i-1);
                }
                $(this).tabs('options').onSelect=SelectFun;
            });    
        }    
    });
    $.extend($.fn.linkbutton.methods, {
        addTip:function(jq,size){    
            if(!size) size=9;
            var html="<i style='display:block;background:#f00;border-radius:50%;";
            html+="width:"+size+"px;height:"+size+"px;top:1px;right:1px;position:absolute;'></i>"
            return jq.each(function(){$(this).find('.l-btn-text').append(html);});   
        },
        deleteTip:function(jq){
            return jq.each(function(){    
                $(this).find('i').remove();
            });   
        }
    });
    $.extend($.fn.datagrid.methods, {
        getEditRows:function(jq){
            var editRows=new Array();
            var opts=jq.datagrid('options');
            var idField= opts.idField;
            var rows=jq.datagrid('getRows');
            for(var i=0;i<rows.length;i++){
                var Editors=jq.datagrid('getEditors',i);
                if(!Editors.length) continue;
                var row=rows[i];
                $.each(Editors,function(){
                    var colOpts=jq.datagrid('getColumnOption',this.field);
                    if(colOpts.valueField){
                        row[colOpts.valueField]=$(this.target).getValue();
                        row[this.field]=$(this.target).getText();
                    }else{
                        row[this.field]=$(this.target).getValue();
                    }
                });
                if(opts.idField&&!row[opts.idField]) row[opts.idField]="";
                editRows.push(row);
            }
            return editRows;
        },
        isEditing:function(jq){
            for(var i=0;i<jq.length;i++){
                var rows=$(jq[i]).datagrid('getRows');
                for(var j=0;j<rows.length;j++){
                    var Editors=$(jq[i]).datagrid('getEditors',j);
                    if(Editors.length){
                        return true;
                    }
                }
            }
            return false;    
        },
        addTip:function(jq,btn,size){
            if(!size) size=9;
            if(btn==undefined) btn='保存';
            var html="<i style='display:block;background:#f00;border-radius:50%;";
            html+="width:"+size+"px;height:"+size+"px;top:1px;right:1px;position:absolute;'></i>"
            return jq.each(function(){
                if(isNaN(btn)){
                    $(this).parent().parent().find('.datagrid-toolbar').find('.l-btn-text:contains('+btn+')').append(html);
                }else{
                    $(this).parent().parent().find('.datagrid-toolbar').find('.l-btn-plain').eq(btn).find('.l-btn-text').append(html);
                }
            });   
        },
        deleteTip:function(jq,btn){
            if(btn==undefined) btn='保存';
            return jq.each(function(){
                if(isNaN(btn)){
                    $(this).parent().parent().find('.datagrid-toolbar').find('.l-btn-text:contains('+btn+')').find('i').remove();
                }else{
                    $(this).parent().parent().find('.datagrid-toolbar').find('.l-btn-plain').eq(btn).find('i').remove();
                }
            }); 
        }
    });
    $.extend($.fn.numberbox.defaults, {
        precision:6,
        formatter:function(value){
            if((value!="")&&!isNaN(value)){
                value=parseFloat(value);
                $(this).numberbox('options').value=value;
            }
            return value;
        }
    });
    $.extend($.fn.checkbox.defaults, {
        on:'Y',
        off:'N'
    });
    $.fn.singleCombo = function(opts){
        if(typeof opts =='object'){
            var ChangeTimer;
            $.extend(opts,{
                onChange:function(){
                    clearTimeout(ChangeTimer);
                    var target=this;
                    ChangeTimer=setTimeout(function(){
                        if($(target).combobox('panel').find(":visible").size()==1){
                            var index=$(target).combobox('panel').find(":visible").index();
                            var Data=$(target).combobox('getData');
                            var valueField=$(target).combobox('opts').valueField;
                            $(target).combobox('select',Data[index][valueField]);
                            $(target).combobox('hidePanel');
                        }
                    },300);
                }
            },opts);
            opts.url=opts.url||$.fn.combobox.defaults.url;
            opts.url+=(opts.url.indexOf("?")>-1?'&':'?')+'ClassName='+opts.ClassName+"&QueryName="+opts.QueryName;
            $.each(opts.queryParams,function(key,value){
                opts.url+="&"+key+'='+value;
            });
        }
        return $(this).combobox(opts);
    }
    $.fn.setValue = function(value,text){
        if(text==undefined) text=value;
        return this.each(function(){
            var className=$(this).attr('class');
            if(!className) className="";
            var childClassName=$(this).children().attr('class');
            if(!childClassName) childClassName="";
            if(className.indexOf('combobox-f')>-1){
                var oldValue=$(this).combobox('getValue');
                if(oldValue!=value){
                    $(this).combobox('select',value);
                }
            }else if(className.indexOf('lookup')>-1){
                var oldValue=$(this).lookup('getValue');
                if(oldValue!=value){
                    if(value!=''){
                        var idField=$(this).lookup('options').idField;
                        var grid= $(this).lookup('grid');
                        if(grid){
                            var rows = grid.datagrid('getRows');
                            var find=false;
                            for(var i=0;i<rows.length;i++){
                                if(rows[i][idField]==value){
                                    find=true;
                                    break;
                                }
                            }
                            if(!find){
                                var textField=$(this).lookup('options').textField;
                                var row=$.parseJSON('{"'+idField+'":"'+value+'","'+textField+'":"'+text+'"}');
                                grid.lookup('insertRow',{ index: 0,row:row});
                            }
                        }
                    }
                    $(this).lookup('setValue',value);
                }
            }else if(className.indexOf('combogrid-f')>-1){
                var oldValue=$(this).combogrid('getValue');
                if(oldValue!=value){
                    if(value!=''){
                        var idField=$(this).combogrid('options').idField;
                        var grid= $(this).combogrid('grid');
                        var rows = grid.datagrid('getRows');
                        var find=false;
                        for(var i=0;i<rows.length;i++){
                            if(rows[i][idField]==value){
                                find=true;
                                break;
                            }
                        }
                        if(!find){
                            var textField=$(this).combogrid('options').textField;
                            var row=$.parseJSON('{"'+idField+'":"'+value+'","'+textField+'":"'+text+'"}');
                            grid.datagrid('insertRow',{ index: 0,row:row});
                        }
                    }
                    $(this).combogrid('setValue',value);
                }
            }else if(className.indexOf('numberbox-f')>-1){
                $(this).numberbox('setValue',value);
            }else if(className.indexOf('hisui-switchbox')>-1){
                $(this).switchbox('setValue',((value==true)||(value=='Y'))?true:false);
            }else if(className.indexOf('timespinner-f')>-1){
                $(this).timespinner('setValue',value);
            }else if(className.indexOf('datagrid-f')>-1){
                $(this).datagrid('loadData',value);
            }else if(className.indexOf('datebox-f')>-1){
                $(this).datebox('setValue',value);
            }else if(className.indexOf('checkbox-f')>-1){
                var on=$(this).checkbox('options').on;
                if(on) value=value==on;
                $(this).checkbox('setValue',value).prop("checked",value);
            }else if(className.indexOf('radio-f')>-1){
                $(this).radio('setValue',value);
            }else if(className.indexOf('slider-f')>-1){
                $(this).slider('setValue',value);
            }else if(childClassName.indexOf('kw-section-list')>-1){
                if(value!="") $(this).keywords('select',value);
                else $(this).keywords('clearAllSelected');
            }else if(($(this).prop("tagName")=="INPUT")&&($(this).prop("type")=='checkbox')){
                $(this).prop("checked",value);
            }else if(($(this).prop("tagName")=="INPUT")||($(this).prop("tagName")=="TEXTAREA")){
                $(this).val(value);
            }else if($(this).prop("tagName")=="SELECT"){
                if(!$(this).find("option[value='"+value+"']").size()){
                $('<option value="'+value+'">'+text+'</option>').prependTo($(this));
                }
                $(this).val(value);
            }else{
                $(this).text(value);
            }
        });
    }
    $.fn.setData = function(data){
        return this.each(function(){
            var className=$(this).attr('class');
            if(!className) className="";
            var childClassName=$(this).children().attr('class');
            if(!childClassName) childClassName="";
            if(className.indexOf('combobox-f')>-1){
                $(this).combobox('loadData',data);
            }else if(className.indexOf('combogrid-f')>-1){
                $(this).combogrid('loadData',data);
            }else if(className.indexOf('datagrid-f')>-1){
                $(this).datagrid('loadData',data);
            }if($(this).prop("tagName")=="SELECT"){
                $(this).maryselect('loadData',data);
            }
        });
    }
    $.fn.getValue = function(){
        var value="";
        var className=this.attr('class');
        if(!className) className="";
        var childClassName=this.children().attr('class');
        if(!childClassName) childClassName="";
        if(className.indexOf('combobox-f')>-1){
            var text=this.combobox('getText');
            if(text!=""){
                value=this.combobox('getValue');
                //if(value==text) value="";
            }
        }else if(className.indexOf('lookup')>-1){
            var text=this.lookup('getText');
            if(text!=""){
                value=this.lookup('getValue');
                //if(value==text) value="";
            }
        }else if(className.indexOf('combogrid-f')>-1){
            var text=this.combogrid('getText');
            if(text!=""){
                value=this.combogrid('getValue');
                //if(value==text) value="";
            }
        }else if(className.indexOf('numberbox-f')>-1){
            value=this.numberbox('getValue');
            if((value!="")&&!isNaN(value)) value=parseFloat(value);
        }else if(className.indexOf('hisui-switchbox')>-1){
            value=this.switchbox('getValue');
        }else if(className.indexOf('timespinner-f')>-1){
            value=this.timespinner('getValue');
        }else if(className.indexOf('datagrid-f')>-1){
            value=this.datagrid('getRows');
        }else if(className.indexOf('datebox-f')>-1){
            value=this.datebox('getValue');
        }else if(className.indexOf('checkbox-f')>-1){
            var opts=$(this).checkbox('options');
            var on=opts.on,off=opts.off;
            value=this.checkbox('getValue');
            if(on) value=value?on:off;
        }else if(className.indexOf('radio-f')>-1){
            value=this.radio('getValue');
        }else if(className.indexOf('slider-f')>-1){
            value=this.slider('getValue');
        }else if(childClassName.indexOf('kw-section-list')>-1){
            value=this.keywords('getSelected');
        }else if((this.prop("tagName")=="INPUT")&&(this.prop("type")=="checkbox")){
            value=this.prop('checked');
            if(value){
                if(typeof(this.attr('value'))!='undefined')
                    value=this.attr('value');
            }else{
                if(typeof(this.attr('offval'))!='undefined')
                    value=this.attr('offval');
            }
        }else if((this.prop("tagName")=="INPUT")||(this.prop("tagName")=="TEXTAREA")){
            value=this.val();
        }else if(this.prop("tagName")=="SELECT"){
            value=this.val();
        }else{
            value=this.text();
        }
        return value;
    }
    $.fn.getText = function(){
        var text="";
        var className=this.attr('class');
        if(!className) className="";
        var childClassName=this.children().attr('class');
        if(!childClassName) childClassName="";
        if(className.indexOf('combobox-f')>-1){
            text=this.combobox('getText');
        }else if(className.indexOf('lookup')>-1){
            text=this.lookup('getText');
        }else if(className.indexOf('combogrid-f')>-1){
            text=this.combogrid('getText');
        }else if(className.indexOf('numberbox-f')>-1){
            text=this.numberbox('getValue');
            if((text!="")&&!isNaN(text)) text=parseFloat(text);
        }else if(className.indexOf('hisui-switchbox')>-1){
            text=this.switchbox('getValue');
        }else if(className.indexOf('timespinner-f')>-1){
            text=this.timespinner('getValue');
        }else if(className.indexOf('datebox-f')>-1){
            text=this.datebox('getValue');
        }else if(childClassName.indexOf('kw-section-list')>-1){
            text=this.keywords('getSelected');
        }else if((this.prop("tagName")=="INPUT")||(this.prop("tagName")=="TEXTAREA")){
            text=this.val();
        }else if(this.prop("tagName")=="SELECT"){
            text=this.find('option[value="'+this.val()+'"]').text();
        }else{
            text=this.text();
        }
        return text;
    }
    $.fn.showMask=function(loadMsg){
        if(this.children("div.datagrid-mask").size()) return;
        if(!loadMsg) loadMsg='加载中...';
        this.append("<div class=\"datagrid-mask\" style=\"display:block\"></div>");
        var msg=$("<div class=\"datagrid-mask-msg\" style=\"display:block;left:50%\"></div>").html(loadMsg).appendTo(this);
        msg._outerHeight(40).css({marginLeft:(-msg.outerWidth()/2),lineHeight:(msg.height()+"px")});
    }
    $.fn.hideMask=function(){
        this.find('div.datagrid-mask-msg,div.datagrid-mask').remove();
    }
})(jQuery);
function ShowHISUIWindow(title,src,iconCls,width,height)
{
    if(!width) width=900;
    if(!height) height=500;
    if(!$('#_HUI_Model_Win').size()){
        $("body").append("<div id='_HUI_Model_Win' class='hisui-window' style='overflow:hidden;'></div>");
    }
    if((arguments.length==1)&&(typeof arguments[0]=='object')){
        var opts=$.extend({
            width:width,
            height:height,
            collapsible:false,
            maximizable:false,
            minimizable:false,
            modal:true,
            content:"<iframe width='100%' height='100%' frameborder='0' src='"+arguments[0].src+"'></iframe>"
        },arguments[0]);
    }else{
        var opts={
            iconCls:iconCls,
            width:width,
            height:height,
            title:title,
            collapsible:false,
            maximizable:false,
            minimizable:false,
            modal:true,
            content:"<iframe width='100%' height='100%' frameborder='0' src='"+src+"'></iframe>"
        };
    }
    $('#_HUI_Model_Win').window(opts).window('center');
}
function CloseHISUIWindow()
{
    if($('#_HUI_Model_Win').size()){
        $('#_HUI_Model_Win').window('close');
    }
}
function GetDGEditRowIndex(target)
{
    if(typeof(target)=='string') target='#'+target;
    var EditRow=$(target).closest("[datagrid-row-index]").attr("datagrid-row-index");
    if(typeof(EditRow)==undefined) EditRow="";
    return EditRow;
}
function GetDateObj(DateStr)
{
    var dim=dtseparator;
    if(!dim) dim=DateStr.indexOf('/')>-1?'/':'-';
    var formater=dtformat||'YMD';
    var dateArr=DateStr.split(dim);
    var dateObj=new Array();
    for(var i=0;i<formater.length;i++){
        var c=formater.charAt(i);
        dateObj[c]=parseInt(dateArr[i]);
    }
    return new Date(dateObj.Y,dateObj.M-1,dateObj.D);
}
function GetDateAddDays(DateStr,Days)
{
    var date = GetDateObj(DateStr);
    date.setDate(date.getDate()+parseInt(Days));
    return $.fn.datebox.defaults.formatter(date);
}
function GetDateWeek(DateStr)
{
    var date = GetDateObj(DateStr);
    var Week=date.getDay();
    if(Week==0) Week=7;
    return Week;
}
function GetCurrentDate()
{
    return $.fn.datebox.defaults.formatter(new Date());
}
function GetCurrentTime()
{
    var date = new Date();
    var h=date.getHours();
    if(h<10) h='0'+h;
    var m=date.getMinutes();
    if(m<10) m='0'+m;
    var s=date.getSeconds();
    if(s<10) s='0'+s;
    return h+':'+m+':'+s;
}
function CompareDate(s1,s2){
    var d1=GetDateObj(s1);
    var d2=GetDateObj(s2);
    if(d1>d2) return 1;
    if(d1<d2) return -1;
    return 0;
}
function GetDateDiffDay(dateStr1,dateStr2){
    var date1 = GetDateObj(dateStr1);
    var date2 = GetDateObj(dateStr2);
    return (date1.getTime()-date2.getTime())/(24 * 60 * 60 * 1000); 
};
function TableToExcel(selector)
{
    try{
        var oXL = new ActiveXObject("Excel.Application");  
        var length=$(selector).size();
        $(selector).each(function(index,element){
            var oWB = oXL.Workbooks.Add();  
            var oSheet = oWB.ActiveSheet;
            var $rows=$(this).children('tbody').children('tr');
            for(var i=0;i<$rows.size();i++){
                var row=i+1
                $cols=$rows.eq(i).children('td');
                for(var j=0;j<$cols.size();j++){
                    var col=j+1;
                    oSheet.Cells(row,col).Value=$cols.eq(j).text();
                }
            }
            if((length-1)==index){
                oXL.Visible = true; 
            }
        });
    }catch(e){
        alert(e.message);
    }
}
function SuportCSSProperty(property,value)
{
    var element = document.createElement('div');
    if(property in element.style){
        if(typeof value=='undefined') return true;
        element.style[property] = value;
       return element.style[property] === value;
    }
    return false;
}
function GetClientIPAddress()
{
    try{
        var locator=new ActiveXObject("WbemScripting.SWbemLocator");
        var service=locator.ConnectServer(".");
        var properties = service.ExecQuery("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled =True");
        var e = new Enumerator(properties);
        var p = e.item();
        var IPAddress=p.IPAddress(0);
        return IPAddress;
    }catch(e){
        return ''
    }
}
function GetCacheIPAddress(){
	
	var IPAddressStr=$.cm({ 
		ClassName:"User.DHCClientLogin",
		MethodName:"GetInfo", 
		dataType:"text"
	},false);
	var IPAddress=IPAddressStr.split("^")[0]
	return IPAddress;
}