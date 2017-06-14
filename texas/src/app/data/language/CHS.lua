local tbl = {}

tbl.char = {
    [","] = "，", [":"] = "：", [";"] = "；", ["!"] = "！",
    ["["] = "『", ["]"] = "』", ["."] = "。", ["?"] = "？",
}

tbl.default = {
    roundnum = "牌局", joinrate = "入局率", 
    winrate = "胜率", fliprate = "摊牌率",
    maxcardtype = "最大牌型",

    roomnum  = "房号",
    raise = "倍", player = "玩家", cards = "手牌", rank = "牌型",
    addscore = "积分",
    pot = "底池", whitehand = "白手起家(6人)", poker = "扑克牌",
    limit = "5-A限注(1倍底池)", 
    fold = "弃牌", call = "跟", raise = "加注", allin = "全下",
    check = "让牌"
}

tbl.rank = {
    [1] = "高牌", [2] = "一对", [3] = "两对",
    [3] = "三条", [4] = "顺子", [5] = "同花",
    [6] = "葫芦", [7] = "四条", [8] = "同花顺",
    [9] = "皇家同花顺",   
}

tbl.tips = {
    roomnum = "请输入房间号",
    room = "亲，该房间", fail = "创建失败", unexist = "不存在",
    full = "已满",
}

tbl.number = {
    [0] = "零", "一", "二", "三", "四", "五",
    "六", "七", "八", "九", "十", 
}

tbl.button = {
    ready = "准备", ok = "确定", logout = "登出", exit = "退出",
    cancel = "取消",
}

tbl.title = {
    sharing = "分享", setting = "设置", friends = "朋友圈",
    wechat = "微信群", sound = "音效", music = "音乐",
    roomnum = "房号",
}

tbl.verb = {
    clean = "重输", delete = "删除",
}

return tbl