//TreeLoader扩展,支持josn-plugin返回的json对象中包含的数组值   
Ext.tree.JsonPluginTreeLoader = function (config) {
    this.rootName = '';
    Ext.tree.JsonPluginTreeLoader.superclass.constructor.call(this, config);
}
Ext.extend(Ext.tree.JsonPluginTreeLoader, Ext.tree.TreeLoader, {
    processResponse: function (response, node, callback, scope) {
        var json = response.responseText;
        try {
            var o = response.responseData || Ext.decode(json);
            //在原代码基础上增加了下面处理---------------------   
            if (Ext.type(o) == 'object') {//如果返回的是对象则获取他的root部分,rootName是可以在使用的时候配置的
                if (this.rootName != '') {
                    o = o[this.rootName];
                }
            }
            //--------------------------------------------------   
            node.beginUpdate();
            for (var i = 0, len = o.length; i < len; i++) {
                var n = this.createNode(o[i]);
                if (n) {
                    node.appendChild(n);
                }
            }
            node.endUpdate();
            this.runCallback(callback, scope || node, [node]);
        } catch (e) {
            this.handleFailure(response);
        }
    }
});