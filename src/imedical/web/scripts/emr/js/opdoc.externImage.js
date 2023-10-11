/// fnCallBack 回调函数，参数为base64编码的图片
var externImage = (function() {
    function wacom(argParams) {
        if (typeof DCActiveX == 'undefined') {
            try {
                $('#hiddenSpan').append('<object id="DCActiveX" classid="clsid:3348afb7-7b31-43d9-a508-3048c5b41c20" codebase="DCActiveX.cab#version=1,0,1" style="display:none;height:1px;width:1px;"></object>');
            } catch (e) {
                //$.messager.alert('发生错误', e.message, 'error');
                alert(e.message);
            }
        }
        //检测是否连有手写板，没有则调用编辑器自带图片编辑模块，编辑图片，兼容原有功能
        if (!DCActiveX.GetInkCanvasState){
            argParams.FnEmrEdtImg();
            return;
        }
        try {
            if (DCActiveX.readyState == 4) {
                var prefix = 'data:image/bmp;base64,';
                var fnCallBack = function(pic_base64) {
                    pic_base64 = pic_base64 || '';
                    if (pic_base64.length > 0) {
                        argParams.FnEmrImg('.bmp', pic_base64.replace(prefix, ''));
                    }
                    //注销对象事件
                    if (DCActiveX.detachEvent){
                        DCActiveX.detachEvent('GetBase64CodeImage', fnCallBack);
                        DCActiveX.detachEvent('DcActiveXExit', fnCallBack);
                    }else{
                        DCActiveX.removeEventListener('GetBase64CodeImage', fnCallBack);
                        DCActiveX.removeEventListener('DcActiveXExit', fnCallBack);
                    }
                }
                //var pic_base64 = argParams.Image || test_img;
                var pic_base64 = argParams.Image || '';
                if (pic_base64.length > 0 && pic_base64.substring(0, prefix.length) !== prefix) {
                    pic_base64 = prefix + pic_base64;
                }
                //检测是否连有手写板
                if (DCActiveX.GetInkCanvasState()) {
                    //添加事件到对象
                    if (DCActiveX.attachEvent){
                        DCActiveX.attachEvent('GetBase64CodeImage', fnCallBack);
                        DCActiveX.attachEvent('DcActiveXExit', fnCallBack);
                    }else{
                        DCActiveX.addEventListener('GetBase64CodeImage', fnCallBack);
                        DCActiveX.addEventListener('DcActiveXExit', fnCallBack);
                    }
                    DCActiveX.ShowInkCanvas('123456', '000001', pic_base64); //123456为demo中使用的部门编号
                    //实际操作入参
                    //DCActiveX.ShowInkCanvas(argParams.UserLocID, argParams.UserID, '');
                }else {
                    if (pic_base64.length > 0) {
                        argParams.FnEmrEdtImg();
                    }else {
                        //$.messager.alert('提示', '当前没有连接手写板,请连接！', 'info');
                        alert("当前没有连接手写板,请连接！");
                    }
                }
            } else {
                //$.messager.alert('警示', '手写板控件加载失败,请安装手写板控件！', 'warning');
                alert("手写板控件加载失败,请安装手写板控件！");
            }
        } catch (err) {
            ////$.messager.alert('发生错误', err.message || err, 'error');
            alert(err.message || err);
        }

    }
    function test(argParams) {
        argParams.FnEmrImg('JPG', test_img);
    }

    //处理多种输入源
    function showChoice(argParams) {
        var methods = argParams['Methods'] || {};
        if ((typeof methods == 'object') && (Object.prototype.toString.call(methods) === '[object Array]')) {
            //多方法，弹窗要用户选择
            return '';
        } else if ((typeof methods == 'string') && (Object.prototype.toString.call(methods) == '[object String]')) {
            return methods;
        }
        
        return '';
    }

    return {
        get: function(argParams) {
            if ('' != argParams['EdtImgPath'] ) {
                //检测是否连有手写板？？？待完善
                argParams['Methods'] = 'wacom';
            }
            var method = showChoice(argParams);
            if ('wacom' == method) {
                wacom(argParams);
            } 
            else if ('test' == method) {
                test(argParams);
            }
            else {
                argParams.FnEmrEdtImg();
            }
        }
    }

})();
var test_img = "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";