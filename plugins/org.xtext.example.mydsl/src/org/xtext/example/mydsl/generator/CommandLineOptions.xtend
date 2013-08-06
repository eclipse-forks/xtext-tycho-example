package org.xtext.example.mydsl.generator

import com.google.inject.Singleton
import java.io.File
import java.util.Collection
import org.apache.commons.cli.GnuParser
import org.apache.commons.cli.HelpFormatter
import org.apache.commons.cli.Options
import org.apache.commons.cli.ParseException
import org.apache.commons.cli.Option

@Singleton
class CommandLineOptions {
	
	val options = new Options 
	
	val outputDirOption = CommandLineOptionsJava.outputDirOption
	
	var File outputPath
	
	var Collection<File> inputFiles = newArrayList
	
	var hasHelp = false
	
	new() {
		options.addOption(new Option( "help", "print this message" ))
		options.addOption(outputDirOption)
	}
	
	def parse(String[] args) {
		val parser = new GnuParser() 
		try {
			val line = parser.parse(options, args)
			hasHelp = line.hasOption("help")
			if (hasHelp)
				return true
			if (line.getOptionValue(outputDirOption.getOpt()) != null) {
				outputPath = new File(line.getOptionValue(outputDirOption.getOpt()))
				if (outputPath.exists) {
					inputFiles = line.argList.map [ new File (it)].toList
					if (inputFiles.size == 0) {
						System.err.println("No input files given")
						return false;
					}
					val nonExistingFile = inputFiles.findFirst [ !it.exists() ]
					if (nonExistingFile != null) {
						 System.err.println ("Unknown file " +  nonExistingFile)
						 return false 
					}
					return true
				} else {
					System.err.println("Output directory '" + outputPath + "' doesn't exists")
				}				
			} else {
				System.err.println("Required option -" + outputDirOption.getOpt() + " not specified")
				printHelpMessage()
			}
	 	} catch (ParseException exp) {
			System.err.println("Parsing arguments failed.  Reason: " + exp.getMessage())
			printHelpMessage()
		}			
		false
	}
	
	def printHelpMessage() {
		new HelpFormatter().printHelp(MyDslC.name.split("\\.").last + " [OPTION]... [FILE]...", options)
	}
	
	def hasHelp () {
		hasHelp	
	}
	
	def Collection<File> getInputFiles() {
		inputFiles
	}
	
	def File getOutputPath() {
		outputPath
	}
	
}