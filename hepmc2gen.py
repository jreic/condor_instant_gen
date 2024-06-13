#!/usr/bin/env cmsRun

## Original Author: Andrea Carlo Marini
## Porting to 92X HepMC 2 Gen
## Date of porting: Mon Jul  3 11:52:22 CEST 2017
## Example of hepmc -> gen file



import FWCore.ParameterSet.Config as cms
from FWCore.ParameterSet.VarParsing import VarParsing

process = cms.Process("GEN")

options = VarParsing ('analysis')

options.register ('randomSeed',
    1243987,
    VarParsing.multiplicity.singleton,
    VarParsing.varType.int,
    'random seed'
)

options.inputFiles = ['file:my_out.hepevt2']
options.randomSeed = 1243987
options.parseArguments()

process.source = cms.Source("MCFileSource",
                    fileNames = cms.untracked.vstring(options.inputFiles)

                        )


process.maxEvents = cms.untracked.PSet(input = cms.untracked.int32(-1))

process.source.firstLuminosityBlockForEachRun = cms.untracked.VLuminosityBlockID(cms.LuminosityBlockID(1,1))

process.load("FWCore.MessageService.MessageLogger_cfi")
process.MessageLogger.cerr.threshold = 'INFO'

process.GEN = cms.OutputModule("PoolOutputModule",
                               fileName = cms.untracked.string('HepMC_GEN.root'),
                               SelectEvents = cms.untracked.PSet(
                                   SelectEvents = cms.vstring('p')
                               ),
)



process.filter = cms.EDFilter("MCMultiParticleFilter",
                              EtaMax = cms.vdouble(1.6, 1.6),
                              Status = cms.vint32(1, 1),
                              PtMin = cms.vdouble(7.0, 7.0),
                              ParticleID = cms.vint32(13, -13),
                              NumRequired = cms.int32(1),
                              AcceptMore = cms.bool(True),
)

process.filter.src = cms.untracked.InputTag("source","generator")

process.load('Configuration.StandardSequences.Services_cff')
process.load('SimGeneral.HepPDTESSource.pythiapdt_cfi')
process.load('GeneratorInterface.Core.genFilterSummary_cff')
process.load('Configuration.StandardSequences.Generator_cff')
#process.genParticles.src= cms.InputTag("source","generator")
process.genParticles.src= cms.InputTag("generatorSmeared")


######### Smearing Vertex example

from IOMC.EventVertexGenerators.VtxSmearedParameters_cfi import GaussVtxSmearingParameters,VtxSmearedCommon
VtxSmearedCommon.src=cms.InputTag("source","generator") 
process.generatorSmeared = cms.EDProducer("GaussEvtVtxGenerator",
    GaussVtxSmearingParameters,
    VtxSmearedCommon
    )
process.load('Configuration.StandardSequences.Services_cff')
process.RandomNumberGeneratorService = cms.Service("RandomNumberGeneratorService",
    generatorSmeared  = cms.PSet( 
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed),
    ),
    CTPPSFastRecHits = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    LHCTransport = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    MuonSimHits = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    VtxSmeared = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    ecalPreshowerRecHit = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    ecalRecHit = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    externalLHEProducer = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    famosPileUp = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    fastSimProducer = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    fastTrackerRecHits = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    g4SimHits = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    generator = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    hbhereco = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    hfreco = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    hiSignal = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    hiSignalG4SimHits = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    hiSignalLHCTransport = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    horeco = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    l1ParamMuons = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    mix = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    mixData = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    mixGenPU = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    mixRecoTracks = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    mixSimCaloHits = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    paramMuons = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    simBeamSpotFilter = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    simMuonCSCDigis = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    simMuonDTDigis = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    simMuonGEMDigis = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    simMuonRPCDigis = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    ),
    simSiStripDigiSimLink = cms.PSet(
        engineName = cms.untracked.string('MixMaxRng'),
        initialSeed = cms.untracked.uint32(options.randomSeed)
    )
)


###################
#process.p = cms.Path(process.filter * process.generatorSmeared * process.genParticles) # to apply muon filter (no longer our baseline plan)
process.p = cms.Path(process.generatorSmeared * process.genParticles) # no filter
process.outpath = cms.EndPath(process.GEN)
