import Prism

func tuiSuccess(_ text: String) {
  let fmtText = Prism {
    Bold {
      BackgroundColor(.green) {
        ForegroundColor(.white) {
          " Success "
        }
      }
    }
    ForegroundColor(.green) {
      text
    }
  }

  print(fmtText)
}

func tuiInfo(_ text: String) {
  let fmtText = Prism {
    Bold {
      BackgroundColor(.blue) {
        ForegroundColor(.white) {
          " Info "
        }
      }
    }
    ForegroundColor(.blue) {
      text
    }
  }

  print(fmtText)
}

func tuiError(_ text: String) {
  let fmtText = Prism {
    Bold {
      BackgroundColor(.red) {
        ForegroundColor(.white) {
          " Error "
        }
      }
    }
    ForegroundColor(.red) {
      text
    }
  }

  print(fmtText)
}

func tuiWarning(_ text: String) {
  let fmtText = Prism {
    Bold {
      BackgroundColor(.yellow) {
        ForegroundColor(.black) {
          " Warning "
        }
      }
    }
    ForegroundColor(.yellow) {
      text
    }
  }

  print(fmtText)
}
