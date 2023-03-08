#!/bin/bash

#SBATCH --job-name=run_preprocess
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50GB
#SBATCH --time=48:00:00
#SBATCH --gres=gpu:0
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=mt4493@nyu.edu
#SBATCH --output=slurm_run_preprocessing_%j.out

module purge

cd /scratch/mt4493/bot_detection/code/TwiBot-22/src/Kouvela

singularity exec --overlay /scratch/mt4493/just_another_day/singularity/tweepy.ext3:ro \
	    /scratch/work/public/singularity/cuda11.1-cudnn8-devel-ubuntu18.04.sif \
	    /bin/bash -c "source /ext3/env.sh; python3 user_to_post.py --datasets Twibot-22"
echo 'user_to_post done'

singularity exec --overlay /scratch/mt4493/just_another_day/singularity/tweepy.ext3:ro \
	    /scratch/work/public/singularity/cuda11.1-cudnn8-devel-ubuntu18.04.sif \
	    /bin/bash -c "source /ext3/env.sh; python3 user_feature_extraction.py --datasets Twibot-22"
echo 'user_feature_extraction done'

cd Twibot-22
singularity exec --overlay /scratch/mt4493/just_another_day/singularity/tweepy.ext3:ro \
	    /scratch/work/public/singularity/cuda11.1-cudnn8-devel-ubuntu18.04.sif \
	    /bin/bash -c "source /ext3/env.sh; python3 tweet_split.py"
echo 'tweet_split done'

singularity exec --overlay /scratch/mt4493/just_another_day/singularity/tweepy.ext3:ro \
	    /scratch/work/public/singularity/cuda11.1-cudnn8-devel-ubuntu18.04.sif \
	    /bin/bash -c "source /ext3/env.sh; python3 content_feature_extraction.py"
echo 'content_feature_extraction done'

cd ..

singularity exec --overlay /scratch/mt4493/just_another_day/singularity/tweepy.ext3:ro \
	    /scratch/work/public/singularity/cuda11.1-cudnn8-devel-ubuntu18.04.sif \
	    /bin/bash -c "source /ext3/env.sh; python3 merge_feature.py --datasets Twibot-22"
echo 'merge_feature done'

