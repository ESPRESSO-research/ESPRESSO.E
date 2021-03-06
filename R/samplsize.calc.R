#'  
#' @title Calculates the sample size required to achieve the desired power
#' @description Estimates by how much the simulated study size needs to be 
#' inflated or shrank in order to obtain the specified level of power. 
#' The ratio of z-statistic required for desired power to mean model z-statistic 
#' obtained indicates the relative changes in standard error required. 
#' This corresponds to the relative change on scale and square root of sample size.
#' @param numcases number of cases when outcome is binary.
#' @param numcontrols number of controls when outcome is binary.
#' @param num.subjects number of subjects when outcome is quantitative.
#' @param pheno.model outcome model, binary=0 and quantitafive=1.
#' @param pval cut-off p-value defining statistical significance.
#' @param power desired power
#' @param mean.model.z ratio of mean beta estimate over mean se estimate
#' @return A table containing:
#' \code{numcases.required} number of cases required to achieve the desired power under binary outcome model
#' \code{numcontrols.required} number of controls required to achieve the desired power under binary outcome model
#' \code{numsubjects.required} number of subjects required to achieve the desired power under a quantitative outcome model
#' @keywords internal
#' @author Gaye A.
#'
samplsize.calc <- function (numcases = 2000, numcontrols = 8000, num.subjects = 500, 
    pheno.model = 0, pval = 1e-04, power = 0.8, mean.model.z = NULL) 
{
    if (is.null(mean.model.z)) {
        cat("\n\n ALERT!\n")
        cat(" The argument 'mean.model.z' is set to NULL.\n")
        cat(" This argument should be the ratio 'mean.beta/mean.se'.\n")
        stop(" End of process!\n\n", call. = FALSE)
    }
    z.pval <- qnorm(1 - pval/2)
    z.power.required <- qnorm(power) + z.pval
    sample.size.inflation.required <- (z.power.required/mean.model.z)^2
    if (pheno.model == 0) {
        cases <- round(numcases * sample.size.inflation.required, 
            0)
        controls <- round(numcontrols * sample.size.inflation.required, 
            0)
        return(list(numcases.required = cases, numcontrols.required = controls))
    }
    else {
        subjects <- round(num.subjects * sample.size.inflation.required, 
            0)
        return(list(numsubjects.required = subjects))
    }
}

