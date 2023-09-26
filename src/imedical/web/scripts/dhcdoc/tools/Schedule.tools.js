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
        $.messager.alert('提示','Init Combo Error','error');
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
        debugger;
        $.messager.alert('提示','Init Grid Error','error');
    }
});
$.extend($.fn.combogrid.defaults, {
    idField:"id",
    treeField:"text",
    mode:'remote',
    url:'DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Grid',
    onLoadError:function(){
        debugger;
        $.messager.alert('提示','Init Grid Error','error');
    }
});
$.extend($.fn.tree.defaults, {    
    url:'DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Tree',
    onLoadError:function(){
        debugger;
        $.messager.alert('提示','Init Tree Error','error');
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
        $.messager.alert('提示','Init TreeGrid Error','error');
    }
});
$.extend($.fn.datagrid.defaults.editors, {   
    textarea: {   
        init: function(container, options){   
                var input = $('<textarea class="datagrid-editable-input" rows='+options.rows+'></textarea>').appendTo(container);   
                return input;   
            },   
        getValue: function(target){   
                return $(target).val();   
            },   
        setValue: function(target, value){   
                    $(target).val(value);   
                },   
        resize: function(target, width){   
                var input = $(target);   
                if ($.boxModel == true){   
                    input.width(width - (input.outerWidth() - input.width()));   
                } else {   
                    input.width(width);   
                }   
            }   
    }   
});
$.fn.singleCombo = function(options){
    var ChangeTimer;
    $.extend(options,{
        onChange:function(){
            clearTimeout(ChangeTimer);
            var target=this;
            ChangeTimer=setTimeout(function(){
                if($(target).combobox('panel').find(":visible").size()==1){
                    var index=$(target).combobox('panel').find(":visible").index();
                    var Data=$(target).combobox('getData');
                    var valueField=$(target).combobox('options').valueField;
                    $(target).combobox('select',Data[index][valueField]);
                    $(target).combobox('hidePanel');
                }
            },300);
        }
    },options);
    options.url=options.url||$.fn.combobox.defaults.url;
    options.url+=(options.url.indexOf("?")>-1?'&':'?')+'ClassName='+options.ClassName+"&QueryName="+options.QueryName;
    if(options.queryParams){
        for(var key in options.queryParams){
            options.url+="&"+key+'='+options.queryParams[key];
        }
    }
    $(this).combobox(options);
}
function SetElementValue(target,value)
{
    if(typeof(target)=='string') target='#'+target;
    if(!$(target).size()) return false;
    var className=$(target).attr('class');
    if(!className) className="";
    var childClassName=$(target).children().attr('class');
    if(!childClassName) childClassName="";
    if(className.indexOf('combobox-f')>-1){
        $(target).combobox('select',value);
    }else if(className.indexOf('numberbox-f')>-1){
        $(target).numberbox('setValue',value);
    }else if(className.indexOf('hisui-switchbox')>-1){
        if((value==true)||(value=='Y')) value=true;
        else value=false;
        $(target).switchbox('setValue',value);
    }else if(className.indexOf('timespinner-f')>-1){
        $(target).timespinner('setValue',value);
    }else if(className.indexOf('datagrid-f')>-1){
        $(target).datagrid('loadData',value);
    }else if(className.indexOf('datebox-f')>-1){
        $(target).datebox('setValue',value);
    }else if(childClassName.indexOf('kw-section-list')>-1){
        $(target).keywords('select',value);
    }else if($(target).prop("tagName")=="INPUT"){
        $(target).val(value);
    }else{
        $(target).text(value);
    }
    return true;
}
function GetElementValue(target)
{
    if(typeof(target)=='string') target='#'+target;
    var value="";
    if(!$(target).size()) return value;
    var className=$(target).attr('class');
    if(!className) className="";
    var childClassName=$(target).children().attr('class');
    if(!childClassName) childClassName="";
    if(className.indexOf('combobox-f')>-1){
        var text=$(target).combobox('getText');
        if(text!=""){
            value=$(target).combobox('getValue');
            if(value==text) value="";
        }
    }else if(className.indexOf('numberbox-f')>-1){
        value=$(target).numberbox('getValue');
    }else if(className.indexOf('hisui-switchbox')>-1){
        value=$(target).switchbox('getValue');
    }else if(className.indexOf('timespinner-f')>-1){
        value=$(target).timespinner('getValue');
    }else if(className.indexOf('datagrid-f')>-1){
	    var dataGridData=$(target).datagrid('getData');
	    if (dataGridData.originalRows) {
        	value=dataGridData.originalRows;
        }else{
	        value=dataGridData.rows;
	    }
    }else if(className.indexOf('datebox-f')>-1){
        value=$(target).datebox('getValue');
    }else if(childClassName.indexOf('kw-section-list')>-1){
        value=$(target).keywords('getSelected');
    }else if($(target).prop("tagName")=="INPUT"){
        value=$(target).val();
    }else{
        value=$(target).text();
    }
    return value;
}
function ClearTabs(ID){
    var SelectFun=$('#'+ID).tabs('options').onSelect;
    $('#'+ID).tabs('options').onSelect=function(){};
    var length=$('#'+ID).tabs('tabs').length;
	for(var i=length;i>0;i--){
		$('#'+ID).tabs('close',i-1);
	}
    $('#'+ID).tabs('options').onSelect=SelectFun;
}
function CheckGridEditing(target)
{
    if(typeof(target)=='string') target='#'+target;
    var rows=$(target).datagrid('getRows');
    if(!rows) return false;
    for(var i=0;i<rows.length;i++){
        var Editors=$(target).datagrid('getEditors',i);
        if(Editors.length){
            return true;
        }
    }
    return false;
}
function AddSaveTip(target,size)
{
    if(typeof(target)=='string') target='#'+target;
    if(!size) size=9;
    var html="<i style='display:block;background:#f00;border-radius:50%;";
    html+="width:"+size+"px;height:"+size+"px;top:1px;right:1px;position:absolute;'></i>"
    $(target).append(html);
    return true;
}
function DeleteSaveTip(target)
{
    if(typeof(target)=='string') target='#'+target;
    $(target).find('i').remove();
    return true;
}
function AddDGTBSaveTip(id,btnText){
    if(!btnText) btnText="保存"
    var target=$('#'+id).parent().parent().find('.datagrid-toolbar').find('.l-btn-text:contains('+btnText+')');
    AddSaveTip(target);
}
function DeleteDGTBSaveTip(id,btnText)
{
    if(!btnText) btnText="保存"
    var target=$('#'+id).parent().parent().find('.datagrid-toolbar').find('.l-btn-text:contains('+btnText+')');
    DeleteSaveTip(target);
}
function ShowHISUIWindow(title,src,iconCls,width,height)
{
    if(!width) width=900;
    if(!height) height=500;
    if(!$('#ShowMode_Win').size()){
        $("body").append("<div id='ShowMode_Win' class='hisui-window'></div>");
    }
    $('#ShowMode_Win').window({
        iconCls:iconCls,
        width:width,
        height:height,
        title:title,
        collapsible:false,
        maximizable:false,
        minimizable:false,
        modal:true,
        content:"<iframe width='99.5%' height='99%' frameborder='0' src='"+src+"'></iframe>"
    });
}
function CloseHISUIWindow()
{
    if($('#ShowMode_Win').size()){
        $('#ShowMode_Win').window('close');
    }
}
function GetDGEditRowIndex(target)
{
    if(typeof(target)=='string') target='#'+target;
    var EditRow=$(target).parents("[datagrid-row-index]").attr("datagrid-row-index");
    if(typeof(EditRow)==undefined) EditRow="";
    return EditRow;
}
function GetDateAddDays(DateStr,Days)
{
    var date = new Date(DateStr);
    date.setDate(date.getDate()+parseInt(Days));
    var y=date.getFullYear();
    var m=date.getMonth()+1;
    if(m<10) m='0'+m;
    var d=date.getDate();
    if(d<10) d='0'+d;
    return y+'-'+m+'-'+d;
}
function GetDateWeek(DateStr)
{
    var date = new Date(DateStr);
    var Week=date.getDay();
    if(Week==0) Week=7;
    return Week;
}
function GetCurrentDate()
{
    var date = new Date();
    var y=date.getFullYear();
    var m=date.getMonth()+1;
    if(m<10) m='0'+m;
    var d=date.getDate();
    if(d<10) d='0'+d;
    return y+'-'+m+'-'+d;
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
    var d1=new Date(s1);
    var d2=new Date(s2);
    if(d1>d2) return 1;
    if(d1<d2) return -1;
    return 0;
}
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