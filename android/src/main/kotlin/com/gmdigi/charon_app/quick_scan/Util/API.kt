package com.gmdigi.charon_app.quick_scan.Util

object API {
    private var resultHandler: ResultHandler? = null
    /**
     * Assign result handler to be passed needed events
     */
    fun setResultHandler(resultHandler: ResultHandler) {
        this.resultHandler = resultHandler
    }

    /**
     * This interface defines what result to be reported to
     * the outside world
     */
    interface ResultHandler {
        fun onReceive(msg: String)
    }

    fun getmsg(msg: String) {
        resultHandler!!.onReceive(msg)
    }

    fun getmsg_call(msg: String): String {
        resultHandler!!.onReceive(msg)
        return "OK"
    }
}

object MESSAGE_TYPE {
    val DEEP_LINK = "charon.deep.link"
    val NOTIFICATION = "charon.notification"
}